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
                <Button textColor={selectedFilter === true ? "#FFF" : "#5393ff"} style={{ marginRight: 8 }} mode={selectedFilter ? "contained" : "text"} onPress={() => setSelectedFilter(true)}>
                    arrival
                </Button>
                <Button textColor={selectedFilter === false ? "#FFF" : "#5393ff"} style={{ marginRight: 8 }} mode={selectedFilter ? "text" : "contained"} onPress={() => setSelectedFilter(false)}>
                    departure
                </Button>
            </View>
            <FlatList
                data={displayedClocks}
                renderItem={renderClock}
                keyExtractor={item => item.id}
            />
        </>

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
        marginLeft: 16
    }
})

export default History