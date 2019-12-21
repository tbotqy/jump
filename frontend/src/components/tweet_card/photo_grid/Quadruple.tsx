import React from "react";
import {
  GridList,
  GridListTile
} from "@material-ui/core";

interface Props {
  urls: string[];
}

export const Quadruple: React.FC<Props> = ({ urls }) => (
  <GridList cols={ 2 }>
    { urls.map( url =>
      <GridListTile rows={ 1 } cols={ 1 } key={ url } >
        <img src={ url } alt={ url } />
      </GridListTile>
    ) }
  </GridList>
);

export default Quadruple;
