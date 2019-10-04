import React, { useState } from "react";
import { Button } from "@material-ui/core";
import { withStyles } from "@material-ui/core/styles";
import blue from "@material-ui/core/colors/blue";
import TwitterIcon from "@material-ui/icons/Twitter";
import { SIGN_IN_URL } from "../utils/paths";

const styles = theme => ({
  button: {
    backgroundColor: blue["400"],
    color: "white",
    textTransform: "none",
    "&:hover": {
      backgroundColor: blue["600"]
    }
  },
  icon: {
    marginRight: theme.spacing(1)
  }
});

const SignInButton = ({ text, classes, ...others }) => {
  const [ disabled, setDisabled ] = useState(false);
  return(
    <Button { ...others } className={ classes.button } href={ SIGN_IN_URL } disabled={ disabled } onClick={ () => setDisabled(true) } >
      <TwitterIcon fontSize="small" className={ classes.icon } />
      { text }
    </Button>
  );
};

export default withStyles(styles)(SignInButton);
