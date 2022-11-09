
import { useEffect } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { getWorkingTimes, getSchedules, getUserClocks, getUserStatus } from '../../http/api';
import { setCurrentUserClocks } from '../../stores/reducers/currentUserClocksReducer';
import { setCurrentUserStatus } from '../../stores/reducers/currentUserStatusReducer';
import { setSchedules } from '../../stores/reducers/schedulesReducer';
import { setWorkingtimes } from '../../stores/reducers/workingtimesReducer';

const DataLoader = (props) => {

    const dispatch = useDispatch();

    const currentUser = useSelector((state) => state.currentUser.value)

    useEffect(() => {
        if (currentUser) {
            getSchedules(currentUser.token).then(({ data }) => {
                dispatch(
                    setSchedules(data)
                )
            })

            getWorkingTimes(currentUser.token, currentUser.user.id).then(({ data }) => {
                dispatch(
                    setWorkingtimes(data)
                )
            })

            getUserStatus(currentUser.token, currentUser.user.id)
                .then((status) => dispatch(
                    setCurrentUserStatus(status.data ? status.data : "no data")
                ))

            getUserClocks(currentUser.token, currentUser.user.id)
                .then(({ data }) =>
                    dispatch(
                        setCurrentUserClocks(data)
                    ))
        }
    }, [currentUser]);


    return props.children
}

export default DataLoader