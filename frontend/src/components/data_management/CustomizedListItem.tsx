import React from "react";
import { AxiosPromise } from "axios";
import {
  ListSubheader,
  ListItem,
  ListItemText,
  ListItemSecondaryAction,
  Button,
  ListItemIcon,
  LinearProgress,
  Theme,
  createStyles,
  WithStyles
} from "@material-ui/core";
import { withStyles } from "@material-ui/core/styles";
import { Autorenew as AutorenewIcon } from "@material-ui/icons";
import {
  API_NORMAL_CODE_OK,
  API_NORMAL_CODE_ACCEPTED
} from "../../api";

const styles = (theme: Theme) => (
  createStyles({
    progressBarWrapper: {
      position: "relative"
    },
    progressBar: {
      position: "absolute",
      width: "100%"
    },
    buttonIcon: {
      marginRight: theme.spacing(1)
    }
  })
);

interface Props extends WithStyles<typeof styles> {
  headerText: string;
  icon: any;
  numberText: string;
  updatedAt: string;
  apiFunc: () => AxiosPromise;
}

interface State {
  isRequesting: boolean;
  buttonDisabled: boolean;
  buttonText: string;
}

class CustomizedListItem extends React.Component<Props, State> {
  state = {
    isRequesting:   false,
    buttonDisabled: false,
    buttonText:     "更新する"
  };

  render() {
    return (
      <>
        <ListSubheader>
          { this.props.headerText }
        </ListSubheader>
        <ListItem>
          <ListItemIcon>
            { this.props.icon }
          </ListItemIcon>
          <ListItemText primary={ this.props.numberText } secondary={ this.props.updatedAt } />
          <ListItemSecondaryAction>
            <div className={ this.props.classes.progressBarWrapper }>
              <Button color="primary" disabled={ this.state.buttonDisabled } onClick={ this.onButtonClick.bind(this) }>
                <AutorenewIcon className={ this.props.classes.buttonIcon } />
                { this.state.buttonText }
              </Button>
              { this.state.isRequesting && <LinearProgress className={ this.props.classes.progressBar } /> }
            </div>
          </ListItemSecondaryAction>
        </ListItem>
      </>
    );
  }

  async onButtonClick() {
    this.setState({
      isRequesting:   true,
      buttonDisabled: true
    });
    try {
      const response = await this.props.apiFunc();
      switch(response.status) {
      case API_NORMAL_CODE_OK:
        this.setState({ buttonText: "更新しました" });
        break;
      case API_NORMAL_CODE_ACCEPTED:
        this.setState({ buttonText: "受け付けました" });
        break;
      default:
        throw new Error(`Unexpected status code returned from API: ${response.status}`);
      }
    } finally {
      this.setState({ isRequesting: false });
    }
  }
}

export default withStyles(styles)(CustomizedListItem);
