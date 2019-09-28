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
import { fetchAuthenticatedUser } from "../../utils/api";
import {
  SIGN_OUT_URL,
  DATA_PATH
} from "../../utils/paths";

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
      fetchAuthenticatedUser()
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
                <MenuItem component={ Link } to={ DATA_PATH }>
                  <ListItemIcon>
                    <AutorenewIcon />
                  </ListItemIcon>
                  <ListItemText primary="データ管理" />
                </MenuItem>
              }
              <MenuItem component="a" href={ SIGN_OUT_URL }>
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
