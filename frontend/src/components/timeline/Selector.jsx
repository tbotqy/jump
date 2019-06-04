import React from "react";
import {
  Fab,
  Menu,
  MenuItem
} from "@material-ui/core";

function Selector(props) {
  const [ anchorEl, setAnchorEl ] = React.useState(null);
  const [ value, setValue ] = React.useState(props.initialValue);

  function handleClick(event) {
    setAnchorEl(event.currentTarget);
  }

  function handleClose() {
    setAnchorEl(null);
  }

  function handleSelect(value) {
    setAnchorEl(null);
    setValue(value);
  }

  return (
    <React.Fragment>
      <Fab variant="extended" color="primary" onClick={ handleClick }>{ value || "-" }</Fab>
      <Menu anchorEl={ anchorEl } open={ Boolean(anchorEl) } onClose={ handleClose }>
        {
          !props.disableNullValue &&
          <MenuItem onClick={ () => handleSelect(null) }>
            <em>未指定</em>
          </MenuItem>
        }
        { props.selections.map((selection, i) => (
          <MenuItem key={ i } onClick={ () => handleSelect(selection) } >
            { selection }
          </MenuItem>
        )) }
      </Menu>
    </React.Fragment>
  );
}

export default Selector;
