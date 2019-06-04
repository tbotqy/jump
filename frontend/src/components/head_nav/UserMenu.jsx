import React from "react";
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
            { this.MyMenuItem(<AutorenewIcon />, "データ管理", "/data") }
            { this.MyMenuItem(<ExitToAppIcon />, "ログアウト", "/") }
          </MenuList>
        </Menu>
      </React.Fragment>
    );
  }

  MyMenuItem(icon, text, href) {
    return (
      <MenuItem component="a" href={ href }>
        <ListItemIcon>
          { icon }
        </ListItemIcon>
        <ListItemText primary={ text } />
      </MenuItem>
    );
  }

  UserAvatar() {
    return <Avatar src="https://pbs.twimg.com/profile_images/2447778203/rad31469gu8q3161ad40_bigger.jpeg" />;
  }
}

export default UserMenu;
