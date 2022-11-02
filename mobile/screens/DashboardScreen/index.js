import * as React from 'react';
import Dashboard from '../../components/Dashboard';
import ScreenLayout from '../../layouts/ScreenLayout/index';

const DashboardScreen = ({ navigation }) => {
    return <ScreenLayout>
        <Dashboard />
    </ScreenLayout>
}

export default DashboardScreen;