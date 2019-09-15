import React from "react";
import AdSense from "react-adsense";

const clientId = process.env.REACT_APP_AD_ID;

const Ad = props => (
  <AdSense.Google
    client={ clientId }
    slot={ props.slot }
    responsive="true"
  />
);

export default Ad;
