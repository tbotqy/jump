import React from "react";
import AdSense from "react-adsense";

const clientId = process.env.REACT_APP_AD_ID;

const Ad = props => (
  process.env.NODE_ENV === "development" ?
    <>広告</> :
    <AdSense.Google
      client={ clientId }
      slot={ props.slot }
      responsive="true"
    />
);

export default Ad;
