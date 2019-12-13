import React from "react";
import MuiTwitterIcon from "@material-ui/icons/Twitter";
import { TWITTER_BRAND_COLOR } from "../utils/colors";

interface Props {
  className: string;
}

const TwitterIcon: React.FC<Props> = props => (
  <MuiTwitterIcon htmlColor={ TWITTER_BRAND_COLOR } { ...props } />
);

export default TwitterIcon;
