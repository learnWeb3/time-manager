import { createSlice } from '@reduxjs/toolkit'

export const currentUserStatusSlice = createSlice({
    name: 'currentUserStatus',
    initialState: {
        value: null,
    },
    reducers: {
        setCurrentUserStatus: (state, action) => {
            state.value = action.payload
        },
    },
})

// Action creators are generated for each case reducer function
export const { setCurrentUserStatus } = currentUserStatusSlice.actions

export default currentUserStatusSlice.reducer