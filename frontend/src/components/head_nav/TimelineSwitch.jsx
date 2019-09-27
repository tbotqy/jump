import React from "react";
import { Link } from "react-router-dom";
import {
  Button,
  Menu,
  MenuList,
  MenuItem,
  ListItemIcon,
  ListItemText
} from "@material-ui/core";
import { withStyles } from "@material-ui/styles";

import {
  Public as PublicIcon,
  People as PeopleIcon,
  Person as PersonIcon
} from "@material-ui/icons";
import {
  USER_TIMELINE_PATH,
  HOME_TIMELINE_PATH,
  PUBLIC_TIMELINE_PATH
} from "../../utils/paths";

const styles = () => ({
  button:{
    color: "grey"
  },
  listItemText: {
    whiteSpace: "normal"
  }
});

class TimelineSwitch extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      anchorEl: null
    };
  }

  render() {
    return(
      <React.Fragment>
        <Button
          onClick={ (e) => this.setState({ anchorEl: e.currentTarget }) }
          className={ this.props.classes.button }
          size="small"
        >
          { this.timelineType() }
        </Button>
        <Menu
          anchorEl={ this.state.anchorEl }
          open={ Boolean(this.state.anchorEl) }
          onClose={ () => this.setState( { anchorEl: null } ) }
        >
          <MenuList>
            { this.MyMenuItem(<PersonIcon />, "あなた", "あなたのツイートを表示します", USER_TIMELINE_PATH) }
            { this.MyMenuItem(<PeopleIcon />, "ホーム", "あなたがフォローしている人のツイートを表示します", HOME_TIMELINE_PATH) }
            { this.MyMenuItem(<PublicIcon />, "パブリック", "みんなのツイートを表示します", PUBLIC_TIMELINE_PATH) }
          </MenuList>
        </Menu>
      </React.Fragment>
    );
  }

  MyMenuItem(icon, primaryText, secondaryText, href) {
    return (
      <MenuItem component={ Link } to={ href }>
        <ListItemIcon>
          { icon }
        </ListItemIcon>
        <ListItemText
          primary={ primaryText }
          secondary={ secondaryText }
          className={ this.props.classes.listItemText }
        />
      </MenuItem>
    );
  }

  timelineType() {
    const currentPath = window.location.pathname;
    if(currentPath.includes(USER_TIMELINE_PATH)) {
      return "あなたのタイムライン";
    }else if(currentPath.includes(HOME_TIMELINE_PATH)) {
      return "ホームタイムライン";
    }else if(currentPath.includes(PUBLIC_TIMELINE_PATH)) {
      return "パブリックタイムライン";
    }else{
      return "タイムラインを選択";
    }
  }
}

export default withStyles(styles)(TimelineSwitch);
