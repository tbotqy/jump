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
  ListItemText,
  CircularProgress
} from "@material-ui/core";
import {
  ExitToApp as ExitToAppIcon,
  Autorenew as AutorenewIcon
} from "@material-ui/icons";

class UserMenu extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      anchorEl: null,
      fetchingUser: false
    };
  }

  componentDidMount() {
    if(!this.props.user) {
      this.setState({ fetchingUser: true });
      this.props.fetchUser()
        .then( response => this.props.setUser(response.data) )
        .catch( error => this.props.setApiErrorCode(error.response.status) )
        .finally( () => this.setState({ fetchingUser: false }) );
    }
  }

  render() {
    if(this.props.user) {
      return (
        <React.Fragment>
          <IconButton color="default" onClick={ (e) => this.setState( { anchorEl: e.currentTarget } ) } >
            { this.UserAvatar() }
          </IconButton>
          <Menu anchorEl={ this.state.anchorEl } open={ Boolean(this.state.anchorEl) } onClose={ () => this.setState( { anchorEl: null } ) }>
            <Box>
              <CardHeader
                avatar={ this.UserAvatar() }
                title={ this.props.user.name }
                subheader={ `@${this.props.user.screen_name}` }
              />
            </Box>
            <Divider />
            <MenuList>
              { !this.props.hideLinkToData &&
                <MenuItem component={ Link } to="/data">
                  <ListItemIcon>
                    <AutorenewIcon />
                  </ListItemIcon>
                  <ListItemText primary="データ管理" />
                </MenuItem>
              }
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
    } else {
      return this.state.fetchingUser && <CircularProgress />;
    }
  }

  UserAvatar() {
    return <Avatar src={ this.props.user.avatar_url } />;
  }
}

export default UserMenu;
