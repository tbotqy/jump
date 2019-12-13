import React from "react";
import { Link as RouterLink } from "react-router-dom";
import {
  withStyles,
  WithStyles,
  createStyles
} from "@material-ui/core/styles";
import Link from "@material-ui/core/Link";
import { ROOT_PATH } from "../utils/paths";

const styles = createStyles({
  brandText: {
    fontFamily: "Fugaz One",
    color: "#32325d"
  }
});

const serviceName = process.env.REACT_APP_SERVICE_NAME;

type Props = WithStyles<typeof styles>

const BrandLogo: React.FC<Props> = ({ classes }) => (
  <Link underline="none" component={ RouterLink } to={ ROOT_PATH }>
    <span className={ classes.brandText }>{ serviceName }</span>
  </Link>
);

export default withStyles(styles)(BrandLogo);
