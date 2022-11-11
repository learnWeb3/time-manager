import * as React from 'react';
import { useSelector } from 'react-redux';
import { FlatList } from 'react-native';
import ScheduleListItem from '../ScheduleListItem/index';

const Timetable = () => {

    const currentUser = useSelector((state) => state.currentUser.value)
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

    React.useEffect(() => {
        if (schedules && workingtimes) {
            setFormattedSchedules(
                formatSchedules(schedules, workingtimes)
            )
        }
    }, [schedules, workingtimes])

    const renderFormattedSchedule = ({ item: schedule }) => {
        return <ScheduleListItem key={schedule.id} schedule={schedule} currentUser={currentUser} />
    }
    return (
        <FlatList
            data={formattedSchedules}
            renderItem={renderFormattedSchedule}
            keyExtractor={item => item.id}
        />
    )
}

export default Timetable