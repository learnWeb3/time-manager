import * as React from 'react';
import { Image, SafeAreaView, ScrollView, StyleSheet, View } from 'react-native';
import { Button, Text } from 'react-native-paper';
import LoginForm from '../../components/LoginForm';
import BottomBar from '../../components/BottomBar';

import ScreenLayout from '../../layouts/ScreenLayout';
import logo from '../../assets/time_manager_icon.png'


const LoginScreen = () => {
   return <View style={{ flex: 1}}>
            <View style={styles.image}>
               <Image style={{ marginTop: 30, height: 45, width:'80%', resizeMode: 'stretch', maxWidth: "80%" }} source={require('../../assets/time_manager_icon.png')} />
            </View>
            <View style={styles.text}>
               <Text style={{fontFamily:"Poppins",color:"#001f54"}} variant="headlineMedium">Sign in</Text>
            </View>
            <View style={styles.login} >
               <LoginForm />
            </View>
   </View>
  


}

const styles = StyleSheet.create({
   image: {
      flex: 2,
      alignItems: 'center',
      justifyContent: 'center',
   },
   text: {
      alignItems: 'center',
      justifyContent: 'center',
   },
   login: {
      flex: 4,
      padding: 30
   }
},
);

export default LoginScreen;