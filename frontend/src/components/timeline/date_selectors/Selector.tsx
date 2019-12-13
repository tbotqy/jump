import React from "react";
import {
  Fab,
  Menu,
  MenuItem
} from "@material-ui/core";

interface Props {
  selections: string[];
  selectedValue: string;
  selectedValueUpdater: (value: string) => void;
}

const Selector: React.FC<Props> = ({ selections, selectedValue, selectedValueUpdater }) => {
  const [ anchorEl, setAnchorEl ] = React.useState<Element | null>(null);

  const handleClick = (event: React.MouseEvent<HTMLButtonElement>) => setAnchorEl(event.currentTarget);

  const handleClose = () => setAnchorEl(null);

  const handleItemSelect = (value: string) => {
    setAnchorEl(null);
    selectedValueUpdater(value);
  };

  if(selections.length > 0) {
    return(
      <>
        <Fab variant="extended" color="primary" onClick={ handleClick }>{ selectedValue }</Fab>
        <Menu anchorEl={ anchorEl } open={ Boolean(anchorEl) } onClose={ handleClose }>
          {
            selections.map((selection, i) => (
              <MenuItem key={ i } onClick={ () => handleItemSelect(selection) } >
                { selection }
              </MenuItem>
            ))
          }
        </Menu>
      </>
    );
  }else{
    return <></>;
  }
};

export default Selector;
