import React from "react";
import {
  Single,
  Double,
  Triple,
  Quadruple
} from "./photo_grid";

interface Props {
  photoUrls: string[];
}

const PhotoGrid: React.FC<Props> = ({ photoUrls }) => {
  switch(photoUrls.length) {
  case 1:
    return <Single url={ photoUrls[0] } />;
  case 2:
    return <Double urls={ photoUrls } />;
  case 3:
    return <Triple urls={ photoUrls } />;
  case 4:
    return <Quadruple urls={ photoUrls } />;
  default:
    throw Error("Unexpected number of urls given.");
  }
};

export default PhotoGrid;
