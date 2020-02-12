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
    <Typography align={align} variant="h2" component="h1" gutterBottom>
      <BrandLogo />
    </Typography>
    <Typography align={align} variant="h4" component="h2" color="textSecondary" gutterBottom>
      過去ツイへひとっ飛び!
    </Typography>
  </>
);

export default LeadText;
