import * as React from 'react';
import { View, StyleSheet, FlatList, ScrollView } from 'react-native';
import { getUserClocks } from '../../http/api';
import ClockInOutListItem from '../ClockInOutListItem';
import { useSelector, useDispatch } from 'react-redux';
import { Button } from 'react-native-paper';
import { ApplicationDate } from '../../date/index';
import { setCurrentUserClocks } from '../../stores/reducers/currentUserClocksReducer';

const History = () => {

    const dispatch = useDispatch()
    const currentUserClocks = useSelector((state) => state.currentUserClocks.value)
    const currentUser = useSelector((state) => state.currentUser.value)
    const [displayedClocks, setDisplayedClocks] = React.useState([])
    const [selectedFilter, setSelectedFilter] = React.useState(true)

    React.useEffect(() => {
        const _displayedClocks = currentUserClocks.filter((clock) => clock.status === selectedFilter)
        setDisplayedClocks(_displayedClocks)
    }, [currentUserClocks, selectedFilter])

    React.useEffect(() => {
        if (currentUser) {
            getUserClocks(currentUser.token, currentUser.user.id)
                .then((userClocks) =>
                    dispatch(
                        setCurrentUserClocks(userClocks.data)
                    ))
        }
    }, [currentUser])

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
                    Deprature
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
        alignItems: "center",
        justifyContent: "start",
        display: "flex",
        flexDirection: "row",
        marginBottom: 16,
    }
})

export default History