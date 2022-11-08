import { NavigationContainer } from '@react-navigation/native';
import * as React from 'react'
import ClockInOutScreen from '../../screens/ClockInOutScreen';
import { routes } from '../../routes/index';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import MaterialCommunityIcons from 'react-native-vector-icons/MaterialCommunityIcons';
import DashboardScreen from '../../screens/DashboardScreen/index';
import HistoryScreen from '../../screens/HistoryScreen';
import ProfileScreen from '../../screens/ProfileScreen/index';
import TimetableScreen from '../../screens/TimetableScreen/index';
import DataLoader from '../DataLoader/index';
import { useSchedulesWorkingTimesSum } from '../../hooks/schedulesWorkingTimeSum';

const Tab = createBottomTabNavigator();

export default function AuthenticatedScreenRouter() {

    const { sum } = useSchedulesWorkingTimesSum()
    return (
        <DataLoader>
            <NavigationContainer>
                <Tab.Navigator>
                    <Tab.Screen name={routes.clockinout.name} options={{
                        title: routes.clockinout.title, tabBarIcon: ({ color, size }) => (
                            <MaterialCommunityIcons name="clock" color={color} size={size} />
                        ),
                    }} >
                        {(props) => <ClockInOutScreen {...props} />}
                    </Tab.Screen>
                    <Tab.Screen name={routes.history.name} options={{
                        title: routes.history.title, tabBarIcon: ({ color, size }) => (
                            <MaterialCommunityIcons name="history" color={color} size={size} />
                        ),
                    }} >
                        {(props) => <HistoryScreen {...props} />}
                    </Tab.Screen>
                    <Tab.Screen name={routes.dashboard.name} options={{
                        title: routes.dashboard.title, tabBarIcon: ({ color, size }) => (
                            <MaterialCommunityIcons name="view-dashboard" color={color} size={size} />
                        ),
                    }} >
                        {(props) => <DashboardScreen {...props} />}
                    </Tab.Screen>
                    <Tab.Screen name={routes.profile.name} options={{
                        title: routes.profile.title, tabBarIcon: ({ color, size }) => (
                            <MaterialCommunityIcons name="account" color={color} size={size} />
                        ),
                    }} >
                        {(props) => <ProfileScreen {...props} />}
                    </Tab.Screen>
                    <Tab.Screen name={routes.timetable.name} options={{
                        title: `${routes.timetable.title} ${sum}`, tabBarIcon: ({ color, size }) => (
                            <MaterialCommunityIcons name="format-list-bulleted" color={color} size={size} />
                        ),
                    }} >
                        {(props) => <TimetableScreen {...props} />}
                    </Tab.Screen>
                </Tab.Navigator>
            </NavigationContainer>
        </DataLoader>
    );
}