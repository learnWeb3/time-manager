import * as React from 'react';
import { View, StyleSheet } from 'react-native';
import ApplicationLineChart from '../LineChart/index';
import { useSelector } from 'react-redux';
import { getUserPresences } from '../../http/api';
import { Button } from 'react-native-paper';

const Dashboard = () => {

    const currentUser = useSelector((state) => state.currentUser.value);
    const viewContainerRef = React.useRef(null);
    const [presenceData, setPresenceData] = React.useState(null)
    const [viewContainerWidth, setViewContainerWidth] = React.useState(0)
    const [selectedPeriodicity, setSelectedPeriodicity] = React.useState("day")

    React.useEffect(() => {
        if (currentUser && selectedPeriodicity) {
            getUserPresences(currentUser.token, currentUser.user.id, selectedPeriodicity)
                .then((data) => setPresenceData(data.data))
        }
    }, [currentUser, selectedPeriodicity])

    React.useEffect(() => {
        if (viewContainerRef) {
            const { width } = viewContainerRef.current.getBoundingClientRect()
            setViewContainerWidth(width)
        }
    }, [viewContainerRef])

    return (
        <View ref={viewContainerRef} style={styles.container}>

            <View style={styles.filterContainer}>
                <Button textColor={selectedPeriodicity === "day" ? "#FFF" : "#001f54"} style={{ marginRight: 8, marginBottom: 8, borderRadius:0, fontSize:10 }} mode={selectedPeriodicity === "day" ? "contained" : "text"} onPress={() => setSelectedPeriodicity("day")}>
                    Day
                </Button>
                <Button textColor={selectedPeriodicity === "week" ? "#FFF" : "#001f54"} style={{ marginRight: 8, marginBottom: 8,borderRadius:0,fontSize:20}} mode={selectedPeriodicity === "week" ? "contained" : "text"} onPress={() => setSelectedPeriodicity("week")}>
                    Week
                </Button>
                <Button textColor={selectedPeriodicity === "month" ? "#FFF" : "#001f54"} style={{ marginRight: 8, marginBottom: 8,borderRadius:0, fontSize :20 }} mode={selectedPeriodicity === "month" ? "contained" : "text"} onPress={() => setSelectedPeriodicity("month")}>
                    Month
                </Button>
                <Button textColor={selectedPeriodicity === "year" ? "#FFF" : "#001f54"} style={{marginRight: 8, marginBottom: 8, borderRadius:0,fontSize:20  }} mode={selectedPeriodicity === "year" ? "contained" : "text"} onPress={() => setSelectedPeriodicity("year")}>
                    Year
                </Button>
            </View>

            {viewContainerWidth && presenceData && <ApplicationLineChart
                legend={['Presence time']}
                labels={presenceData.map((dataItem) => dataItem.periodicity)}
                datasets={[presenceData.map((dataItem) => dataItem.duration / 3600)]}
                width={viewContainerWidth}
            />}
        </View>
    )
}

const styles = StyleSheet.create({
    filterContainer: {
        width:"100%",
        display: "flex",
        flexDirection: "row",
        marginBottom: 30,
        flexWrap: 'wrap',
        shadowColor: '#171717',
        shadowOffset: {width: -2, height: 4},
        shadowOpacity: 0.2,
        shadowRadius: 3,
        height:40,
        justifyContent:"space-evenly"
    },
    container: {
        width: "100%"
    }
})

export default Dashboard