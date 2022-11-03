import { configureStore } from '@reduxjs/toolkit'
import currentUserClocksReducer from './reducers/currentUserClocksReducer';
import currentUserReducer from './reducers/currentUserReducer';
export default configureStore({
    reducer: {
        currentUser: currentUserReducer,
        currentUserClocks: currentUserClocksReducer
    },
})