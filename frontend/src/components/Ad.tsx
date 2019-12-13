import React from "react";
import AdSense from "react-adsense";

const clientId = process.env.REACT_APP_AD_ID;

interface Props {
  slot: string;
}

const Ad: React.FC<Props> = ({ slot }) => (
  process.env.REACT_APP_HIDE_AD ?
    <>広告</> :
    <AdSense.Google
      client={ clientId }
      slot={ slot }
      responsive="true"
    />
);

export default Ad;
