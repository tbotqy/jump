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
  WithStyles,
  Typography
} from "@material-ui/core";
import LockIcon from "@material-ui/icons/Lock";
import TwitterIcon from "./TwitterIcon";
import { User } from "../api";

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
  const { name, screenName, avatarUrl, profileBannerUrl, protectedFlag } = user;
  return(
    <Card className={ classes.card }>
      <CardMedia image={ profileBannerUrl } className={ classes.cardMedia }>
        <IconButton href={ `https://twitter.com/${screenName}` } target="_blank" className={ classes.avatarWrapper }>
          <Avatar src={ avatarUrl.replace("_normal", "") } className={ classes.avatar } />
        </IconButton>
      </CardMedia>
      <CardHeader
        className={ classes.cardHeader }
        title={
        <>
          { protectedFlag && <LockIcon className={ classes.lockIcon } /> }
          <Typography component="h1" variant="h5">
            <Link
              color="inherit"
              href={ `https://twitter.com/${screenName}` }
              target="_blank"
            >
              { name }
            </Link>
          </Typography>
        </>
        }
        subheader={
        <>
          <TwitterIcon className={ classes.twitterIcon } />
          <Link
            color="inherit"
            href={ `https://twitter.com/${screenName}` }
            target="_blank"
          >
            { `@${screenName}` }
          </Link>
        </>
        }
      />
    </Card>
  );
};

export default withStyles(styles)(UserProfile);
