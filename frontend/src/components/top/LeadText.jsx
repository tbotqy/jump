import React from "react";
import { Typography } from "@material-ui/core";
import BrandLogo from "../BrandLogo";

class LeadText extends React.Component {
  render() {
    return (
      <React.Fragment>
        <Typography align={ this.props.align } variant="h2" gutterBottom>
          <BrandLogo />
        </Typography>
        <Typography align={ this.props.align } variant="h4" color="textSecondary" gutterBottom>
          過去ツイへひとっ飛び!
        </Typography>
      </React.Fragment>
    );
  }
}

export default LeadText;
