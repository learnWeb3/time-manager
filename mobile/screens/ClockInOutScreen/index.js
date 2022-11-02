import * as React from 'react';
import CLockInOutForm from '../../components/ClockInOutForm';
import ScreenLayout from '../../layouts/ScreenLayout/index';

const ClockInOutScreen = ({ navigation }) => {
    return <ScreenLayout>
        <CLockInOutForm />
    </ScreenLayout>
}

export default ClockInOutScreen;