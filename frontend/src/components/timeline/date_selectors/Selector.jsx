import React from "react";
import {
  Fab,
  Menu,
  MenuItem
} from "@material-ui/core";

const Selector = props => {
  const [ anchorEl, setAnchorEl ] = React.useState(null);

  const handleClick = event => setAnchorEl(event.currentTarget);

  const handleClose = () => setAnchorEl(null);

  const handleItemSelect = value => {
    setAnchorEl(null);
    props.selectedValueUpdater(value);
  };

  return (
    props.selections.length > 0 &&
    <>
      <Fab variant="extended" color="primary" onClick={ handleClick }>{ props.selectedValue }</Fab>
      <Menu anchorEl={ anchorEl } open={ Boolean(anchorEl) } onClose={ handleClose }>
        {
          props.selections.map((selection, i) => (
            <MenuItem key={ i } onClick={ () => handleItemSelect(selection) } >
              { selection }
            </MenuItem>
          ))
        }
      </Menu>
    </>
  );
};

export default Selector;
