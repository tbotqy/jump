import React from "react";
import { Link } from "react-router-dom";
import {
  Menu,
  MenuItem,
  IconButton,
  Avatar,
  MenuList,
  Box,
  CardHeader,
  Divider,
  ListItemIcon,
  ListItemText
} from "@material-ui/core";
import {
  ExitToApp as ExitToAppIcon,
  Autorenew as AutorenewIcon
} from "@material-ui/icons";

class UserMenu extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      anchorEl: null
    };
  }

  render() {
    return (
      <React.Fragment>
        <IconButton color="default" onClick={ (e) => this.setState( { anchorEl: e.currentTarget } ) } >
          { this.UserAvatar() }
        </IconButton>
        <Menu anchorEl={ this.state.anchorEl } open={ Boolean(this.state.anchorEl) } onClose={ () => this.setState( { anchorEl: null } ) }>
          <Box>
            <CardHeader
              avatar={ this.UserAvatar() }
              title="twitjump"
              subheader="@twitjump_me"
            />
          </Box>
          <Divider />
          <MenuList>
            <MenuItem component={ Link } to="/data">
              <ListItemIcon>
                <AutorenewIcon />
              </ListItemIcon>
              <ListItemText primary="データ管理" />
            </MenuItem>
            <MenuItem component="a" href={ `${process.env.REACT_APP_AUTH_ORIGIN}/sign_out` }>
              <ListItemIcon>
                <ExitToAppIcon />
              </ListItemIcon>
              <ListItemText primary="ログアウト" />
            </MenuItem>
          </MenuList>
        </Menu>
      </React.Fragment>
    );
  }

  UserAvatar() {
    return <Avatar src="https://pbs.twimg.com/profile_images/2447778203/rad31469gu8q3161ad40_bigger.jpeg" />;
  }
}

export default UserMenu;
