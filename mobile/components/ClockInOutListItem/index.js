import * as React from 'react';
import { List } from 'react-native-paper';

const ClockInOutListItem = ({ title, description, }) => {
    return <List.Item
        title={title}
        description={description}
        left={props => <List.Icon {...props} icon="clock" />}
    />
}

export default ClockInOutListItem