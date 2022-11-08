import * as React from 'react';
import { View, StyleSheet, Dimensions } from 'react-native';
import ApplicationLineChart from '../LineChart/index';
import { useSelector } from 'react-redux';
import { getUserPresences } from '../../http/api';
import { Button, Text } from 'react-native-paper';

const Dashboard = () => {

    const currentUser = useSelector((state) => state.currentUser.value);
    const [presenceData, setPresenceData] = React.useState(null)
    const [selectedPeriodicity, setSelectedPeriodicity] = React.useState("day")

    React.useEffect(() => {
        if (currentUser && selectedPeriodicity) {
            getUserPresences(currentUser.token, currentUser.user.id, selectedPeriodicity)
                .then((data) => setPresenceData(data.data))
        }
    }, [currentUser, selectedPeriodicity])

    


    return (
        <View style={styles.container}>

            <View style={styles.filterContainer}>
                <Button textColor={selectedPeriodicity === "day" ? "#FFF" : "#5393ff"} style={{ marginRight: 8, marginBottom: 8 }} mode={selectedPeriodicity === "day" ? "contained" : "text"} onPress={() => setSelectedPeriodicity("day")}>
                    <Text>day</Text>
                </Button>
                <Button textColor={selectedPeriodicity === "week" ? "#FFF" : "#5393ff"} style={{ marginRight: 8, marginBottom: 8 }} mode={selectedPeriodicity === "week" ? "contained" : "text"} onPress={() => setSelectedPeriodicity("week")}>
                    <Text>week</Text>
                </Button>
                <Button textColor={selectedPeriodicity === "month" ? "#FFF" : "#5393ff"} style={{ marginRight: 8, marginBottom: 8 }} mode={selectedPeriodicity === "month" ? "contained" : "text"} onPress={() => setSelectedPeriodicity("month")}>
                    <Text>month</Text>
                </Button>
                <Button textColor={selectedPeriodicity === "year" ? "#FFF" : "#5393ff"} style={{ marginRight: 8, marginBottom: 8 }} mode={selectedPeriodicity === "year" ? "contained" : "text"} onPress={() => setSelectedPeriodicity("year")}>
                    <Text>year</Text>
                </Button>
            </View>
            {presenceData ? <ApplicationLineChart
                legend={['Presence time']}
                labels={presenceData.map((dataItem) => dataItem.periodicity)}
                datasets={[presenceData.map((dataItem) => dataItem.duration / 3600)]}
                width={Dimensions.get('window').width}
            /> : <Text></Text>}
        </View>
    )
}

const styles = StyleSheet.create({
    filterContainer: {
        alignItems: "center",
        justifyContent: "flex-start",
        display: "flex",
        flexDirection: "row",
        marginTop: 16,
        marginBottom: 16,
        marginLeft: 16,
        flexWrap: 'wrap',
    },
    container: {
        width: "100%"
    }
})

export default Dashboard