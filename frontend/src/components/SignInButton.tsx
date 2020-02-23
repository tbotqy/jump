import React, { useState } from "react";
import { Button, Theme, createStyles, WithStyles } from "@material-ui/core";
import { withStyles } from "@material-ui/core/styles";
import blue from "@material-ui/core/colors/blue";
import TwitterIcon from "@material-ui/icons/Twitter";
import { SIGN_IN_URL } from "../utils/paths";
import { ButtonTypeMap } from "@material-ui/core/Button";
import { TWITTER_BRAND_COLOR } from "../utils/colors";

const styles = (theme: Theme) => (
  createStyles({
    button: {
      backgroundColor: TWITTER_BRAND_COLOR,
      color: "white",
      textTransform: "none",
      "&:hover": {
        backgroundColor: blue["600"]
      }
    },
    icon: {
      marginRight: theme.spacing(1)
    }
  })
);

type ButtonProps = Extract<ButtonTypeMap["props"], {}>

interface Props extends ButtonProps, WithStyles<typeof styles> {
  text: string;
}

const SignInButton: React.FC<Props> = ({ text, classes, ...others }) => {
  const [ disabled, setDisabled ] = useState<boolean>(false);
  return(
    <form method="post" action={SIGN_IN_URL} onSubmit={ () => setDisabled(true) }>
      <Button { ...others } className={ classes.button } type="submit" disabled={ disabled } >
        <TwitterIcon fontSize="small" className={ classes.icon } />
        { text }
      </Button>
    </form>
  );
};

export default withStyles(styles)(SignInButton);
