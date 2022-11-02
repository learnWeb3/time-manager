import { configureStore } from '@reduxjs/toolkit'
import currentUserReducer from './reducers/currentUserReducer';
export default configureStore({
    reducer: {
        currentUser: currentUserReducer,
    },
})