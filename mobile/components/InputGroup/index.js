import * as React from 'react';
import { StyleSheet, View } from 'react-native';
import { TextInput, Text } from 'react-native-paper';

const InputGroup = ({label, isError, value, errors, handleInput, secureTextEntry = false }) => {

    return <View style={styles.container}>
        <TextInput
            error={isError}
            label={label}
            value={value}
            secureTextEntry={secureTextEntry}
            onChangeText={email => handleInput(email)}
        />
        {isError && <Text style={styles.errorText} variant="labelSmall">{errors.join(', ')}</Text>}

    </View>

}

const styles = StyleSheet.create({
    container: {
        width: "100%",
        marginBottom: 16
    },
    errorText: {
        marginTop: 8,
        color: "red"
    }
})

export default InputGroup