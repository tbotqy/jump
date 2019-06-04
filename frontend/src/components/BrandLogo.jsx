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

  return (
    <Link { ...others } href="/" underline="none">
      <span className={ classes.brandText }>FooBar</span>
    </Link>
  );
}

export default withStyles(styles)(BrandLogo);
