import { createSlice } from '@reduxjs/toolkit'

export const workingtimesSlice = createSlice({
    name: 'workingtimes',
    initialState: {
        value: null,
    },
    reducers: {
        setWorkingtimes: (state, action) => {
            state.value = action.payload
        },
        appendWorkingTime: (state, action) => {
            state.value = [...state.value, action.payload]
        },
        removeWorkingTime: (state, action) => {
            state.value = state.value.filter((item) => item.id !== action.payload)
        }
    },
})

// Action creators are generated for each case reducer function
export const { setWorkingtimes, appendWorkingTime, removeWorkingTime } = workingtimesSlice.actions

export default workingtimesSlice.reducer