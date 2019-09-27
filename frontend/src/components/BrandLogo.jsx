import React from "react";
import { Link as RouterLink } from "react-router-dom";
import { withStyles } from "@material-ui/core/styles";
import Link from "@material-ui/core/Link";
import { ROOT_PATH } from "../utils/paths";

const styles = {
  brandText: {
    fontFamily: "Fugaz One",
    color: "#32325d"
  }
};

const serviceName = process.env.REACT_APP_SERVICE_NAME;

const BrandLogo = ({ classes, ...others }) => (
  <Link { ...others } underline="none" component={ RouterLink } to={ ROOT_PATH }>
    <span className={ classes.brandText }>{ serviceName }</span>
  </Link>
);

export default withStyles(styles)(BrandLogo);
