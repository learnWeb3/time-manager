import axios from "axios";
import { env } from '../env/index';
import { setCurrentUser } from "../stores/reducers/currentUserReducer";
import { LocalStorage } from '../localstorage/index';

const httpApi = axios.create({
    baseURL: env.API_BASE_URL,
    timeout: 1000,
    headers: { 'Content-Type': 'application/json' }
});

httpApi.interceptors.response.use(function (response) {
    return response;
}, function (error) {
    if (error.response.status === 401) {
        LocalStorage.removeData(env.LOCAL_STORAGE_CURRENT_USER_KEY)
            .then(() => setCurrentUser(null))
    }
    return Promise.reject(error);
});


const mergeAuthHeaders = (axiosInstance, token) => {
    axiosInstance.defaults.headers.common['Authorization'] = `Bearer ${token}`
    return axiosInstance
}

export const login = async (data = { email: "", password: "" }) => {
    return await httpApi.post('/sessions/login', data).then((response) => response.data)
}

export const getUserStatus = (token, userId) => mergeAuthHeaders(httpApi, token)
    .get(`/status/${userId}`,)
    .then((response) => response.data)

export const createClock = (token, userId, data = {
    clock: {
        time: Math.round(Date.now() / 1000)
    }
}) => mergeAuthHeaders(httpApi, token)
    .post(`/clocks/${userId}`, data)
    .then((response) => response.data)

export const getUserClocks = (token, userId) => mergeAuthHeaders(httpApi, token)
    .get(`/clocks/${userId}`)
    .then((response) => response.data)

export const getUserPresences = (token, userId, periodicity = "day") => mergeAuthHeaders(httpApi, token)
    .get(`/clocks/presence?userId=${userId}&periodicity=${periodicity}`)
    .then((response) => response.data)