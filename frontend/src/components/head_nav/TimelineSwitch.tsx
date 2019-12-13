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
import {
  withStyles, WithStyles,
  createStyles
} from "@material-ui/styles";

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

const styles = createStyles({
  button:{
    color: "grey"
  },
  listItemText: {
    whiteSpace: "normal"
  }
});

type Props = WithStyles<typeof styles>

interface State {
  anchorEl: Element | null;
}

class TimelineSwitch extends React.Component<Props, State> {
  state =  { anchorEl: null };

  render() {
    return(
      <React.Fragment>
        <Button
          onClick={ this.onClick.bind(this) }
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

  onClick(e: React.MouseEvent<HTMLButtonElement>) {
    this.setState({ anchorEl: e.currentTarget });
  }

  MyMenuItem(icon: JSX.Element, primaryText: string, secondaryText: string, href: string) {
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
