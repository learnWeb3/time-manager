import { Provider } from 'react-redux';
import stores from './stores';
import * as React from 'react'
import AuthLoader from './components/AuthLoader';
import { MD3LightTheme as DefaultTheme, Provider as PaperProvider } from 'react-native-paper';
import AuthenticationRouter from './components/AuthenticationRouter';


const theme = {
  ...DefaultTheme,
  colors: {
    ...DefaultTheme.colors,
    primary: "#5393ff",
    secondary: '#e91e63'
  },
};

export default function App() {
  return (
    <Provider store={stores}>
      <AuthLoader />
      <PaperProvider theme={theme}>
        <AuthenticationRouter />
      </PaperProvider>
    </Provider>
  );
}