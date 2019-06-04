import React from "react";
import {
  ListSubheader,
  ListItem,
  ListItemText,
  ListItemSecondaryAction,
  Button,
  ListItemIcon
} from "@material-ui/core";
import { withStyles } from "@material-ui/core/styles";
import { Autorenew as AutorenewIcon } from "@material-ui/icons";

const styles = theme => ({
  buttonIcon: {
    marginRight: theme.spacing(1)
  }
});

const CustomizedListItem = (props) => {
  const { classes } = props;
  return (
    <React.Fragment>
      <ListSubheader>
        { props.headerText }
      </ListSubheader>
      <ListItem>
        <ListItemIcon>
          { props.icon }
        </ListItemIcon>
        <ListItemText primary={ props.numberText } secondary={ props.updatedAt } />
        <ListItemSecondaryAction>
          <Button color="primary" onClick={ props.onButtonClick }>
            <AutorenewIcon className={ classes.buttonIcon } />
            更新する
          </Button>
        </ListItemSecondaryAction>
      </ListItem>
    </React.Fragment>
  );
};

export default withStyles(styles)(CustomizedListItem);
