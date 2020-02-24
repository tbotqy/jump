import React, { useState, useEffect } from "react";
import { withRouter, RouteComponentProps } from "react-router-dom";
import clsx from "clsx";
import { withStyles } from "@material-ui/core/styles";
import { Button, Typography, Theme, createStyles, WithStyles } from "@material-ui/core";
import { TwitterShareButton } from "react-share";
import TwitterIcon from "@material-ui/icons/Twitter";
import { TWITTER_BRAND_COLOR } from "../utils/colors";
import blue from "@material-ui/core/colors/blue";

const url = (): string => document.location.href;

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
    iconText: {
      marginLeft: theme.spacing(1)
    },
    iconTextWhite: {
      color: "white"
    }
  })
);

interface Props extends WithStyles<typeof styles>, RouteComponentProps {
  inTwitterBrandColor?: boolean;
}

const ShareButton: React.FC<Props> = ({ classes, match, inTwitterBrandColor = false }) => {
  const [ title, setTitle ] = useState("");
  const iconColor = inTwitterBrandColor ? "white" : "gray";
  const textProps = inTwitterBrandColor ? (
    { className: clsx(classes.iconText, classes.iconTextWhite) }
  ) : (
    { color: "textSecondary" as "textSecondary", className: classes.iconText }
  );

  useEffect(() => setTitle(document.title), [ match.url ]);

  return(
    <TwitterShareButton url={ url() } title={ title } id="btn">
      <Button component="div" className={ clsx({ [classes.button]: inTwitterBrandColor }) }>
        <TwitterIcon htmlColor={ iconColor } fontSize="small" />
        <Typography variant="body2" { ...textProps }>シェア</Typography>
      </Button>
    </TwitterShareButton>
  );
};

export default withRouter(withStyles(styles)(ShareButton));
