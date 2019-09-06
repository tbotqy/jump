import React from "react";
import { Button } from "@material-ui/core";
import { withStyles } from "@material-ui/core/styles";
import blue from "@material-ui/core/colors/blue";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faTwitter } from "@fortawesome/free-brands-svg-icons";
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

function SignInButton(props) {
  const { classes, ...others } = props;
  return (
    <Button { ...others } className={ classes.button } href={ SIGN_IN_URL }>
      <FontAwesomeIcon icon={ faTwitter } className={ classes.icon } />
      { props.text }
    </Button>
  );
}

export default withStyles(styles)(SignInButton);
