
import * as React from 'react';
import { StyleSheet, View } from 'react-native';


const ScreenLayout = (props) => <View style={styles.container}>
    <View style={styles.viewContainer}>
        {props.children}
    </View>
</View>

const styles = StyleSheet.create({
    container: {
        alignItems: 'center',
        height: "100%"
    },
    viewContainer: {
        width: "100%",
        height: "100%",
    }
});

export default ScreenLayout;