import React from "react";
import {
  Button,
  WithStyles,
  createStyles,
  Theme,
  withStyles
} from "@material-ui/core";
import { Input as InputIcon } from "@material-ui/icons";
import { PUBLIC_TIMELINE_PATH } from "../../utils/paths";

const styles = (theme: Theme) => (
  createStyles({
    buttonIcon: {
      marginLeft: theme.spacing(1)
    }
  })
);

type Props = WithStyles<typeof styles>;

const ButtonToPublicTimeline: React.FC<Props> = ({ classes }) => (
  <Button
    size="large"
    fullWidth
    variant="contained"
    color="primary"
    href={PUBLIC_TIMELINE_PATH}
  >
    公開タイムラインを見てみる
    <InputIcon
      fontSize="small"
      className={classes.buttonIcon}
    />
  </Button>
);

export default withStyles(styles)(ButtonToPublicTimeline);
