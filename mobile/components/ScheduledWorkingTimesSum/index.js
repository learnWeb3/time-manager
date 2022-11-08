import * as React from 'react';
import { StyleSheet, View } from 'react-native'
import { Text } from 'react-native-paper';
import { useSelector } from 'react-redux';

const ScheduledWorkingTimesSum = () => {


    const schedules = useSelector((state) => state.schedules.value);
    const workingtimes = useSelector((state) => state.workingtimes.value)
    const [formattedSchedules, setFormattedSchedules] = React.useState([])

    const formatSchedules = (schedules, workingtimes) => {
        const workingtimesbyschedules = workingtimes.reduce((mappingObject, workingtime) => {
            mappingObject[workingtime.schedule_id] = workingtime;
            return mappingObject
        }, {})
        return schedules.map((schedule) => ({
            ...schedule,
            workingtime: workingtimesbyschedules[schedule.id],
        }))
    }

    const calculateWorkingTimeSum = (scheduleWithWorkingTimes) => {
        return scheduleWithWorkingTimes.reduce((sum, schedule) => {
            if (schedule.workingtime) {
                const shiftDuration = (schedule.endhour + (schedule.endminute / 60)) - (schedule.starthour + (schedule.startminute / 60))
                return sum + shiftDuration
            }
            return sum
        }, 0)
    }

    React.useEffect(() => {
        if (schedules && workingtimes) {
            setFormattedSchedules(
                formatSchedules(schedules, workingtimes)
            )
        }
    }, [schedules, workingtimes])

    return <Text>

        {formattedSchedules ? calculateWorkingTimeSum(formattedSchedules) : 0}
    </Text>
}

export default ScheduledWorkingTimesSum