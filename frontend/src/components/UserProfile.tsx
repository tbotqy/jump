import React from "react";
import { withStyles } from "@material-ui/core/styles";
import {
  Card,
  CardMedia,
  CardHeader,
  Avatar,
  IconButton,
  Link,
  Theme,
  createStyles,
  WithStyles
} from "@material-ui/core";
import LockIcon from "@material-ui/icons/Lock";
import TwitterIcon from "./TwitterIcon";
import { User } from "../models/user";

const styles = (theme: Theme) => (
  createStyles({
    card: {
      "boxShadow": "0 0 20px 0 rgba(0,0,0,0.12)"
    },
    cardMedia: {
      width: "100%",
      height: "300px",
      "objectFit": "contain",
      position: "relative"
    },
    avatarWrapper: {
      position: "absolute",
      bottom: "-80px"
    },
    avatar: {
      width:  134,
      height: 134
    },
    cardHeader: {
      paddingLeft: theme.spacing(20)
    },
    lockIcon: {
      position: "relative",
      top: 3,
      marginRight: 6
    },
    twitterIcon: {
      position: "relative",
      top: 7,
      marginRight: 6
    }
  })
);

interface Props extends WithStyles<typeof styles> {
  user: User;
}

const UserProfile: React.FC<Props> = ({ user, classes }) => {
  // TODO: to camel case
  const { name, screen_name, avatar_url, profile_banner_url, protected_flag } = user;
  return(
    <Card className={ classes.card }>
      <CardMedia image={ profile_banner_url } className={ classes.cardMedia }>
        <IconButton href={ `https://twitter.com/${screen_name}` } target="_blank" className={ classes.avatarWrapper }>
          <Avatar src={ avatar_url.replace("_normal", "") } className={ classes.avatar } />
        </IconButton>
      </CardMedia>
      <CardHeader
        className={ classes.cardHeader }
        title={
        <>
          { protected_flag && <LockIcon className={ classes.lockIcon } /> }
          <Link
            color="inherit"
            href={ `https://twitter.com/${screen_name}` }
            target="_blank"
          >
            { name }
          </Link>
        </>
        }
        subheader={
        <>
          <TwitterIcon className={ classes.twitterIcon } />
          <Link
            color="inherit"
            href={ `https://twitter.com/${screen_name}` }
            target="_blank"
          >
            { `@${screen_name}` }
          </Link>
        </>
        }
      />
    </Card>
  );
};

export default withStyles(styles)(UserProfile);
