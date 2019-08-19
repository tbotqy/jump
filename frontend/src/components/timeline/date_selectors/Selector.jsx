import React from "react";
import {
  Fab,
  Menu,
  MenuItem
} from "@material-ui/core";

function Selector(props) {
  const [ anchorEl, setAnchorEl ] = React.useState(null);

  function handleClick(event) {
    setAnchorEl(event.currentTarget);
  }

  function handleClose() {
    setAnchorEl(null);
  }

  function handleItemSelect(value) {
    setAnchorEl(null);
    props.selectedValueUpdater(value);
  }

  return (
    <React.Fragment>
      <Fab variant="extended" color="primary" onClick={ handleClick }>{ props.selectedValue }</Fab>
      <Menu anchorEl={ anchorEl } open={ Boolean(anchorEl) } onClose={ handleClose }>
        { props.selections.map((selection, i) => (
          <MenuItem key={ i } onClick={ () => handleItemSelect(selection) } >
            { selection }
          </MenuItem>
        )) }
      </Menu>
    </React.Fragment>
  );
}

export default Selector;
