import React from "react";
import {
  GridList,
  GridListTile
} from "@material-ui/core";

interface Props {
  urls: string[];
}

const Double: React.FC<Props> = ({ urls }) => (
  <GridList cols={ 2 }>
    { urls.map( url =>
      <GridListTile rows={ 2 } cols={ 1 } key={ url } >
        <img src={ url } alt={ url } />
      </GridListTile>
    ) }
  </GridList>
);

export default Double;
