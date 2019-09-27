import React from "react";
import { Typography } from "@material-ui/core";
import BrandLogo from "../BrandLogo";

const LeadText = ({ align }) => (
  <React.Fragment>
    <Typography align={ align } variant="h2" gutterBottom>
      <BrandLogo />
    </Typography>
    <Typography align={ align } variant="h4" color="textSecondary" gutterBottom>
      過去ツイへひとっ飛び!
    </Typography>
  </React.Fragment>
);

export default LeadText;
