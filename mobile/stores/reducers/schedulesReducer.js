import { createSlice } from '@reduxjs/toolkit'

export const schedulesSlice = createSlice({
    name: 'schedules',
    initialState: {
        value: null,
    },
    reducers: {
        setSchedules: (state, action) => {
            state.value = action.payload
        },
    },
})

// Action creators are generated for each case reducer function
export const { setSchedules } = schedulesSlice.actions

export default schedulesSlice.reducer