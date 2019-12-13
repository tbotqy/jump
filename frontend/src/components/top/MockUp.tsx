import React from "react";
import {
  withStyles,
  WithStyles,
  createStyles
} from "@material-ui/core/styles";
import MockUpImg from "./../../assets/mockup.png";

const styles = createStyles({
  img: {
    "width":    "auto",
    "height":   "auto",
    "maxWidth": "100%",
    "maxHeight":"100%"
  }
});

type Props = WithStyles<typeof styles>

const MockUp: React.FC<Props> = ({ classes }) => (
  <img alt="mockup" src={ MockUpImg } decoding="async" className={ classes.img } />
);

export default withStyles(styles)(MockUp);
