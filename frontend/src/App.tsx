import React from "react";
import { ThemeProvider } from "@material-ui/styles";
import CssBaseline from "@material-ui/core/CssBaseline";
import {
  createMuiTheme,
  responsiveFontSizes,
  Theme
} from "@material-ui/core/styles";
import { Provider } from "react-redux";
import Routes from "./Routes";
import ErrorBoundary from "./components/ErrorBoundary";
import store from "./store";

const theme: Theme = responsiveFontSizes(createMuiTheme({
  palette: {
    background: {
      default: "white"
    }
  }
}));

class App extends React.Component {
  render(): React.ReactNode {
    return (
      <ErrorBoundary>
        <Provider store={ store }>
          <ThemeProvider theme={ theme }>
            <CssBaseline />
            <Routes />
          </ThemeProvider>
        </Provider>
      </ErrorBoundary>
    );
  }
}

export default App;
