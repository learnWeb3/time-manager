
import * as React from 'react';
import { StyleSheet, View } from 'react-native';
import Logo from '../../components/Logo/index';


const ScreenLayout = (props) => <View style={styles.container}>
    <View style={styles.viewContainer}>
        <Logo />
        {props.children}
    </View>
</View>

const styles = StyleSheet.create({
    container: {
        backgroundColor: '#fff',
        alignItems: 'center',
        height: "100%"
    },
    viewContainer: {
        width: "100%",
        padding: 24
    }
});

export default ScreenLayout;