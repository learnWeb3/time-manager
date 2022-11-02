
import * as React from 'react';
import { StyleSheet, View } from 'react-native';


const ScreenLayout = (props) => <View style={styles.container}>
    {props.children}
</View>

const styles = StyleSheet.create({
    container: {
        backgroundColor: '#fff',
        alignItems: 'center',
        justifyContent: 'center',
        padding: 24,
        height: "100%"
    }
});

export default ScreenLayout;