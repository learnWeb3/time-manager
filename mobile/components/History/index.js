import * as React from 'react';
import { View, StyleSheet, FlatList, ScrollView } from 'react-native';
import ClockInOutListItem from '../ClockInOutListItem';
import { useSelector } from 'react-redux';
import { Button } from 'react-native-paper';
import { ApplicationDate } from '../../date/index';

const History = () => {

    const currentUserClocks = useSelector((state) => state.currentUserClocks.value)
    const [displayedClocks, setDisplayedClocks] = React.useState([])
    const [selectedFilter, setSelectedFilter] = React.useState(true)

    React.useEffect(() => {
        const _displayedClocks = currentUserClocks.filter((clock) => clock.status === selectedFilter)
        setDisplayedClocks(_displayedClocks)
    }, [currentUserClocks, selectedFilter])

    const renderClock = ({ item: clock }) => {
        return <ClockInOutListItem key={clock.id} title={ApplicationDate.format(clock.time)} description={""} />
    }

    return (
        <>
            <View style={styles.filterContainer}>
                <Button textColor={selectedFilter === true ? "#FFF" : "#001f54"} style={{ width:"50%", borderRadius:0 , backgroundColor:(selectedFilter ? "#001f54" :"#FFF") }} mode={selectedFilter ? "contained" : "text"} onPress={() => setSelectedFilter(true)}>
                    Arrival
                </Button> 
                <Button textColor={selectedFilter === false ? "#FFF" : "#001f54"} style={{ width:"50%", borderRadius:0 , backgroundColor:(!selectedFilter ? "#001f54" :"#FFF") }} mode={selectedFilter ? "text" : "contained"} onPress={() => setSelectedFilter(false)}>
                    Departure
                </Button>
            </View>
            <ScrollView style={styles.clocksListContainer}>
                <FlatList
                    data={displayedClocks}
                    renderItem={renderClock}
                    keyExtractor={item => item.id}
                />
            </ScrollView>
        </>

    )
}

const styles = StyleSheet.create({
    clocksListContainer: {
        height: "100%"
    },
    filterContainer: {
        fontStyle:"Poppins",
        alignItems: "center",
        justifyContent: "flex-start",
        display: "flex",
        flexDirection: "row",
        marginBottom: 16,
        shadowColor: '#171717',shadowOffset: {width: -2, height: 4},shadowOpacity: 0.2,shadowRadius: 3
    }
})

export default History