import React from "react";
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
    <Link { ...others } href="/" underline="none">
      <span className={ classes.brandText }>{ serviceName }</span>
    </Link>
  );
}

export default withStyles(styles)(BrandLogo);
