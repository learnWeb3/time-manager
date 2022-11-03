import { createSlice } from '@reduxjs/toolkit'

export const currentUserClocksSlice = createSlice({
    name: 'currentUser',
    initialState: {
        value: [],
    },
    reducers: {
        setCurrentUserClocks: (state, action) => {
            state.value = action.payload
        },
        addNewCurrentUserClock: (state, action) => {
            state.value = [...state.value, action.payload]
                .sort((clockA, clockB) => clockB.time - clockA.time)
        }
    },
})

// Action creators are generated for each case reducer function
export const { setCurrentUserClocks, addNewCurrentUserClock } = currentUserClocksSlice.actions

export default currentUserClocksSlice.reducer