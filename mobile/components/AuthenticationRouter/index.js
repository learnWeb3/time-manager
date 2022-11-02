import * as React from 'react'
import AuthenticatedScreenRouter from '../AuthenticatedScreenRouter/index';
import LoginScreen from '../../screens/LoginScreen/index';
import { useSelector } from 'react-redux';

const AuthenticationRouter = () => {
    const currentUser = useSelector((state) => state.currentUser.value)
    return (
        currentUser ? <AuthenticatedScreenRouter /> : <LoginScreen />
    )
}

export default AuthenticationRouter