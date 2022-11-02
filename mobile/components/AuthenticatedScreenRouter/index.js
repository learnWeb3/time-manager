import { NavigationContainer } from '@react-navigation/native';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import * as React from 'react'
import ClockInOutScreen from '../../screens/ClockInOutScreen';

const Stack = createNativeStackNavigator();

export default function AuthenticatedScreenRouter() {
    return (
        <NavigationContainer>
            <Stack.Navigator initialRouteName={"clockinout"}>
                <Stack.Screen name="clockinout" options={{ title: 'Presence' }} >
                    {(props) => <ClockInOutScreen {...props} />}
                </Stack.Screen>
            </Stack.Navigator>
        </NavigationContainer>
    );
}