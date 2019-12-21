import React from "react";
import {
  GridList,
  GridListTile
} from "@material-ui/core";

interface Props {
  url: string;
}

const Single: React.FC<Props> = ({ url }) => (
  <GridList cols={ 1 }>
    <GridListTile rows={ 2 } cols={ 1 }>
      <img src={ url } alt={ url } />
    </GridListTile>
  </GridList>
);

export default Single;
