import * as React from 'react';
import { View, StyleSheet, FlatList } from 'react-native';
import { getUserClocks } from '../../http/api';
import ClockInOutListItem from '../ClockInOutListItem';
import { useSelector } from 'react-redux';
import { Button } from 'react-native-paper';
import { ApplicationDate } from '../../date/index';

const History = () => {

    const currentUser = useSelector((state) => state.currentUser.value)
    const [clocks, setClocks] = React.useState([])
    const [displayedClocks, setDisplayedClocks] = React.useState([])
    const [selectedFilter, setSelectedFilter] = React.useState(true)

    React.useEffect(() => {
        const _displayedClocks = clocks.filter((clock) => clock.status === selectedFilter)
        setDisplayedClocks(_displayedClocks)
    }, [clocks, selectedFilter])
    React.useEffect(() => {
        if (currentUser) {
            getUserClocks(currentUser.token, currentUser.user.id).then((userClocks) => setClocks(userClocks.data))
        }
    }, [currentUser])

    const renderClock = ({ item: clock }) => {
        return <ClockInOutListItem key={clock.id} title={ApplicationDate.format(clock.time)} description={""} />
    }

    return (
        <>
            <View style={styles.filterContainer}>
                <Button color={"primary"} style={{ marginRight: 8 }} mode={selectedFilter ? "contained" : "outlined"} onPress={() => setSelectedFilter(true)}>
                    arrival
                </Button>
                <Button style={{ marginRight: 8 }} mode={selectedFilter ? "outlined" : "contained"} onPress={() => setSelectedFilter(false)}>
                    departure
                </Button>
            </View>
            <View style={styles.clocksListContainer}>
                <FlatList
                    data={displayedClocks}
                    renderItem={renderClock}
                    keyExtractor={item => item.id}
                />
            </View>
        </>

    )
}

const styles = StyleSheet.create({
    clocksListContainer: {

    },
    filterContainer: {
        alignItems: "center",
        justifyContent: "start",
        display: "flex",
        flexDirection: "row",
        marginBottom: 24
    }
})

export default History