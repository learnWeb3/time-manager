import * as React from 'react';
import { List, Text } from 'react-native-paper';

const ClockInOutListItem = ({ title, description, }) => {
    return <List.Item
        style={{borderBottomWidth: 1, borderBottomColor: '#FFF'}}
        color="#FFF"
        title={props => <Text {...props}>{title}</Text>}
        description={description}
        left={props => <List.Icon {...props} icon="clock" color="#1282A2" />}
    />
}

export default ClockInOutListItem