import React from "react";
import { withStyles } from "@material-ui/core/styles";
import { Button, Typography } from "@material-ui/core";
import { TwitterShareButton } from "react-share";
import TwitterIcon from "@material-ui/icons/Twitter";
import { TWITTER_BRAND_COLOR } from "../utils/colors";
import blue from "@material-ui/core/colors/blue";
import clsx from "clsx";

const url = () => document.location.href;

const styles = theme => ({
  button: {
    backgroundColor: TWITTER_BRAND_COLOR,
    color: "white",
    textTransform: "none",
    "&:hover": {
      backgroundColor: blue["600"]
    }
  },
  iconText: {
    marginLeft: theme.spacing(1)
  }
});

const TweetButton = ({ text, buttonText = "ツイート", classes, inTwitterBrandColor = false }) => {
  const iconColor = inTwitterBrandColor ? "white" : "gray";
  const textColor = inTwitterBrandColor ? "white" : "textSecondary";

  return(
    <TwitterShareButton url={ url() } title={ text || document.title }>
      <Button size="small" className={ clsx({ [classes.button]: inTwitterBrandColor }) }>
        <TwitterIcon htmlColor={ iconColor } fontSize="small" />
        <Typography variant="body" color={ textColor } className={ classes.iconText }>{ buttonText }</Typography>
      </Button>
    </TwitterShareButton>
  );
};

export default withStyles(styles)(TweetButton);
