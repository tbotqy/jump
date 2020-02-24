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
  CircularProgress,
  CardActionArea
} from "@material-ui/core";
import {
  ExitToApp as ExitToAppIcon,
  Autorenew as AutorenewIcon
} from "@material-ui/icons";
import {
  SIGN_OUT_URL,
  DATA_PATH,
  USER_PAGE_PATH
} from "../../utils/paths";
import {
  User,
  fetchMe
} from "../../api";
import avatarAltText from "../../utils/avatarAltText";

interface DefaultProps {
  hideLinkToData: boolean;
}

interface Props extends DefaultProps {
  user?: User;
  setUser: (user: User) => void;
}

interface State {
  anchorEl: Element | null;
  fetchingUser: boolean;
}

class UserMenu extends React.Component<Props, State> {
  state = {
    anchorEl: null,
    fetchingUser: false
  };

  public static defaultProps: DefaultProps = {
    hideLinkToData: false
  }

  async componentDidMount() {
    if(!this.props.user) {
      this.setState({ fetchingUser: true });
      try {
        const response = await fetchMe();
        this.props.setUser(response.data);
      } finally {
        this.setState({ fetchingUser: false });
      }
    }
  }

  render() {
    if(this.props.user) {
      return (
        <>
          <IconButton color="default" onClick={ (e) => this.setState( { anchorEl: e.currentTarget } ) } >
            { this.UserAvatar() }
          </IconButton>
          <Menu anchorEl={ this.state.anchorEl } open={ Boolean(this.state.anchorEl) } onClose={ () => this.setState( { anchorEl: null } ) }>
            <Box pb={ 1 }>
              <CardActionArea href={ `${USER_PAGE_PATH}/${this.props.user.screenName}` } target="_blank">
                <CardHeader
                  avatar={ this.UserAvatar() }
                  title={ this.props.user.name }
                  subheader={ `@${this.props.user.screenName}` }
                />
              </CardActionArea>
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
        </>
      );
    } else {
      return this.state.fetchingUser && <CircularProgress />;
    }
  }

  UserAvatar() {
    const { user } = this.props;
    return user && <Avatar src={ user.avatarUrl } alt={avatarAltText(user.name, user.screenName)} />;
  }
}

export default UserMenu;
