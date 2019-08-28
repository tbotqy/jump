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
            { this.MyMenuItem(<PersonIcon />, "あなた", "あなたのツイートを表示します", "/user_timeline") }
            { this.MyMenuItem(<PeopleIcon />, "友達", "あなたがフォローしている人のツイートを表示します", "/home_timeline") }
            { this.MyMenuItem(<PublicIcon />, "パブリック", "みんなのツイートを表示します", "/public_timeline") }
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
    const timelineType = window.location.pathname.split("/")[1];
    switch(timelineType) {
    case "user_timeline":
      return "あなたのタイムライン";
    case "home_timeline":
      return "ホームタイムライン";
    case "public_timeline":
      return "パブリックタイムライン";
    default:
      return "タイムラインを選択";
    }
  }
}

export default withStyles(styles)(TimelineSwitch);
