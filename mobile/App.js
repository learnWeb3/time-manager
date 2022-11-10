import { Provider } from 'react-redux';
import stores from './stores';
import react, { useCallback } from 'react'
import AuthLoader from './components/AuthLoader';
import { MD3LightTheme as DefaultTheme, Provider as PaperProvider } from 'react-native-paper';
import AuthenticationRouter from './components/AuthenticationRouter';
import { useFonts } from 'expo-font';
import * as SplashScreen from 'expo-splash-screen';
import { TextInput, Text } from 'react-native-paper';
import poppins from './assets/fonts/Poppins-SemiBold.ttf'
import orbitron from './assets/fonts/Orbitron-Regular.ttf'



const theme = {
  ...DefaultTheme,
  colors: {
    ...DefaultTheme.colors,
    primary: "#001f54",
    secondary: '#fefcfb'
  },
};
export default function App() {
  const [fontsLoaded] = useFonts({
    'Poppins': poppins,
    'Orbitron':orbitron
  });

  

  return (
    <Provider store={stores}>
      <AuthLoader />
      <PaperProvider theme={theme}>
        <AuthenticationRouter />
      </PaperProvider>
    </Provider>
  );
}