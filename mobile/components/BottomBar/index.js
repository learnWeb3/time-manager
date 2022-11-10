import * as React from 'react';
import { BottomNavigation } from 'react-native-paper';
import ClockInOutScreen from '../../screens/ClockInOutScreen/index';
import { routes as appRoutes } from '../../routes/index';
import DashboardScreen from '../../screens/DashboardScreen/index';
import { View } from 'react-native';


const BottomBar = ({ navigation }) => {
    const [index, setIndex] = React.useState(0);
    const [routes] = React.useState([
        { key: appRoutes.clockinout.name, title: appRoutes.clockinout.title, focusedIcon: 'clock', unfocusedIcon: 'clock' },
        { key: appRoutes.dashboard.name, title: "History", focusedIcon: 'history', unfocusedIcon: 'history' },
        { key: "test", title: "Details", focusedIcon: 'account-outline', unfocusedIcon: 'account-outline' },
    ]);

    const renderScene = BottomNavigation.SceneMap({
        [appRoutes.clockinout.name]: () => ClockInOutScreen,

    });

return (
        <BottomNavigation
        barStyle={{ backgroundColor: '#FEFCFB'}}
        navigationState={{ index, routes }}
        onIndexChange={setIndex}
        renderScene={renderScene}
        />
)
}

export default BottomBar