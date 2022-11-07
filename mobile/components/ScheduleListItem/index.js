import * as React from 'react';
import { List, Text, Button } from 'react-native-paper';
import { ApplicationDate } from '../../date/index';
import { StyleSheet, View } from 'react-native';
import { createWorkingTime, deleteWorkingTime } from '../../http/api';
import { useDispatch } from 'react-redux';
import { appendWorkingTime, removeWorkingTime } from '../../stores/reducers/workingtimesReducer';

const ScheduleListItem = ({ schedule, currentUser }) => {

    console.log(currentUser)

    const dispatch = useDispatch()

    const handleScheduleSubscription = async () => {
        if (!schedule.workingtime) {
            const { data } = await createWorkingTime(currentUser.token, currentUser.user.id, {
                schedule_id: schedule.id
            })
            dispatch(appendWorkingTime(data))
        } else {
            await deleteWorkingTime(currentUser.token, schedule.workingtime.id)
            dispatch(
                removeWorkingTime(schedule.workingtime.id)
            )
        }
    }

    const formatSchedule = () => {

        const numberToDay = {
            0: 'Monday',
            1: 'Tuesday',
            2: 'Wenesday',
            3: 'Thursday',
            4: 'Friday',
            5: 'Saturday',
            6: 'Sunday'
        }

        return `${numberToDay[schedule.weekday]} from ${ApplicationDate.addTrailingZero(schedule.starthour)}:${ApplicationDate.addTrailingZero(schedule.startminute)} to ${ApplicationDate.addTrailingZero(schedule.endhour)}:${ApplicationDate.addTrailingZero(schedule.endminute)}`
    }

    return <List.Item
        onPress={handleScheduleSubscription}
        style={{ borderBottomWidth: 1, borderBottomColor: '#FFF' }}
        color="#FFF"
        title={props => <View style={styles.listItemDataContainer}>
            <Text {...props}>{formatSchedule(schedule)}</Text>
            <Button buttonColor={schedule.workingtime ? '#e91e63' : "#5393ff"} style={{ width: 'max-content', borderRadius: 24 }} mode="contained">
                {schedule.workingtime ? 'unsubscribe' : "subscribe"}
            </Button>
        </View>}
        left={props => <List.Icon {...props} icon="clock" />}
    />
}

const styles = StyleSheet.create({
    listItemDataContainer: {
        display: 'flex',
        justifyContent: 'space-between',
        flexDirection: 'row',
        alignItems: 'center'
    }
})

export default ScheduleListItem