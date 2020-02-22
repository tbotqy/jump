import React from "react";
import { Link } from "react-router-dom";
import {
  Fab,
  Menu,
  MenuItem
} from "@material-ui/core";

interface Props {
  paths: string[];
  selectedValue: string;
}

const Selector: React.FC<Props> = ({ paths, selectedValue }) => {
  const [anchorEl, setAnchorEl] = React.useState<Element | null>(null);

  const handleClick = (event: React.MouseEvent<HTMLButtonElement>) => setAnchorEl(event.currentTarget);

  const handleClose = () => setAnchorEl(null);

  const handleItemSelect = () => setAnchorEl(null);

  if (paths.length <= 0) return null;

  return (
    <>
      <Fab variant="extended" color="primary" onClick={handleClick}>{selectedValue}</Fab>
      <Menu anchorEl={anchorEl} open={Boolean(anchorEl)} onClose={handleClose}>
        {
          paths.map((path, i) => {
            const presence = path.split("/").slice(-1)[0];
            return (
              <li key={i}>
                <MenuItem component={Link} to={path} onClick={handleItemSelect} >
                  {presence}
                </MenuItem>
              </li>
            );
          })
        }
      </Menu>
    </>
  );
};

export default Selector;
