import { configureStore } from '@reduxjs/toolkit'
import currentUserClocksReducer from './reducers/currentUserClocksReducer';
import currentUserReducer from './reducers/currentUserReducer';
import currentUserStatusReducer from './reducers/currentUserStatusReducer';
import isNetworkAvailableReducer from './reducers/isNetworkAvailableReducer';
import schedulesReducer from './reducers/schedulesReducer';
import workingtimesReducer from './reducers/workingtimesReducer';

export default configureStore({
    reducer: {
        currentUser: currentUserReducer,
        currentUserStatus: currentUserStatusReducer,
        currentUserClocks: currentUserClocksReducer,
        schedules: schedulesReducer,
        workingtimes: workingtimesReducer,
        isNetworkAvailable: isNetworkAvailableReducer
    },
})