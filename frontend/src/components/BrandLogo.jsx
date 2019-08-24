import React from "react";
import { Link as RouterLink } from "react-router-dom";
import { withStyles } from "@material-ui/core/styles";
import Link from "@material-ui/core/Link";

const styles = {
  brandText: {
    fontFamily: "Fugaz One",
    color: "#32325d"
  }
};

function BrandLogo(props) {
  const { classes, ...others } = props;
  const serviceName = process.env.REACT_APP_SERVICE_NAME;

  return (
    <Link { ...others } underline="none" component={ RouterLink } to="/">
      <span className={ classes.brandText }>{ serviceName }</span>
    </Link>
  );
}

export default withStyles(styles)(BrandLogo);
