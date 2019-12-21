import React from "react";
import {
  GridList,
  GridListTile
} from "@material-ui/core";

interface Props {
  urls: string[];
}

const Triple: React.FC<Props> = ({ urls }) => (
  <GridList cols={ 2 }>
    <GridListTile rows={ 1 } cols={ 2 } key={ 1 }>
      <img src={ urls[0] } alt={ urls[0] } />
    </GridListTile>
    <GridListTile rows={ 1 } cols={ 1 } key={ 2 }>
      <img src={ urls[1] } alt={ urls[1] } />
    </GridListTile>
    <GridListTile rows={ 1 } cols={ 1 } key={ 3 }>
      <img src={ urls[2] } alt={ urls[2] } />
    </GridListTile>
  </GridList>
);

export default Triple;
