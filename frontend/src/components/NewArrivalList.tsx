import React, { useEffect, useState } from "react";
import { Link } from "react-router-dom";
import shortid from "shortid";
import {
  Grid,
  Box,
  Typography,
  CircularProgress,
  Avatar,
  IconButton,
  WithStyles,
  withStyles,
  createStyles,
} from "@material-ui/core";
import { USER_PAGE_PATH } from "../utils/paths";
import { fetchNewArrivals, NewArrival } from "../api";
import avatarAltText from "../utils/avatarAltText";

const styles = createStyles({
  avatar: {
    width: 50,
    height: 50,
  },
});

type Props = WithStyles<typeof styles>;

const NewArrivalList: React.FC<Props> = ({ classes }) => {
  const [newArrivals, setNewArrivals] = useState<NewArrival[] | undefined>(
    undefined
  );
  useEffect(() => {
    (async() => {
      const response = await fetchNewArrivals();
      setNewArrivals(response.data);
    })();
  }, []);

  const content = () => {
    if (newArrivals) {
      return (
        <Grid
          container
          direction="row"
          alignItems="center"
          justify="space-between"
        >
          {newArrivals.map((user) => (
            <Grid item key={shortid.generate()}>
              <IconButton
                component={Link}
                to={`${USER_PAGE_PATH}/${user.screenName}`}
              >
                <Avatar
                  className={classes.avatar}
                  src={user.avatarUrl.replace("_normal", "_bigger")}
                  alt={avatarAltText(user.name, user.screenName)}
                />
              </IconButton>
            </Grid>
          ))}
        </Grid>
      );
    } else {
      return (
        <Grid container alignItems="center" justify="center">
          <Grid item>
            <CircularProgress />
          </Grid>
        </Grid>
      );
    }
  };

  return (
    <nav>
      <Typography
        gutterBottom
        variant="h5"
        component="h4"
        color="textSecondary"
      >
        新着ユーザー
      </Typography>
      <Box pt={2}>{content}</Box>
    </nav>
  );
};

export default withStyles(styles)(NewArrivalList);
