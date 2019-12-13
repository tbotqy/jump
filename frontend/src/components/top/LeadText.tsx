import React from "react";
import {
  Typography,
  PropTypes
} from "@material-ui/core";
import BrandLogo from "../BrandLogo";

interface Props {
  align?: PropTypes.Alignment;
}

const LeadText: React.FC<Props> = ({ align }) => (
  <>
    <Typography align={ align } variant="h2" gutterBottom>
      <BrandLogo />
    </Typography>
    <Typography align={ align } variant="h4" color="textSecondary" gutterBottom>
      過去ツイへひとっ飛び!
    </Typography>
  </>
);

export default LeadText;
