import React from "react";
import { withStyles } from "@material-ui/core/styles";
import {
  Button,
  Typography,
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
  List,
  ListItem,
  ListItemText,
  ListItemIcon
} from "@material-ui/core";
import {
  Delete as DeleteIcon,
  Person as PersonIcon,
  VpnKey as VpnKeyIcon,
  Textsms as TextsmsIcon,
  People as PeopleIcon
} from "@material-ui/icons";

const styles = theme => ({
  buttonIcon: {
    marginRight: theme.spacing(1)
  }
});

class AccountDeleteDialog extends React.Component {
  constructor(props) {
    super(props);
    this.state = { open: false };
  }

  render() {
    return (
      <React.Fragment>
        <Button color="secondary" onClick={ this.handleClickOpen.bind(this) } >
          <DeleteIcon className={ this.props.classes.buttonIcon } />
          アカウントを削除する
        </Button>
        <Dialog
          open={ this.state.open }
          onClose={ this.handleClose.bind(this) }
          aria-labelledby="alert-dialog-title"
          aria-describedby="alert-dialog-description"
        >
          <DialogTitle disableTypography>
            <Typography variant="h6">
              当サービス上の、以下のデータを削除します
            </Typography>
          </DialogTitle>
          <DialogContent dividers>
            <List>
              { this.MyListItem(<PersonIcon />, "あなたのTwitterプロフィール情報") }
              { this.MyListItem(<VpnKeyIcon />, "あなたのTwitterアカウントへのアクセスキー") }
              { this.MyListItem(<TextsmsIcon />, "保存した全てのあなたのツイート") }
              { this.MyListItem(<PeopleIcon />, "あなたのフォローリスト") }
            </List>
          </DialogContent>
          <DialogActions>
            <Button onClick={ this.handleClose.bind(this) } color="primary">
              キャンセル
            </Button>
            <Button onClick={ () => {} } color="secondary">
              <DeleteIcon className={ this.props.classes.buttonIcon } / >
              実行
            </Button>
          </DialogActions>
        </Dialog>
      </React.Fragment>
    );
  }

  MyListItem(icon, text) {
    return(
      <React.Fragment>
        <ListItem>
          <ListItemIcon>
            { icon }
          </ListItemIcon>
          <ListItemText secondary={ text } />
        </ListItem>
      </React.Fragment>
    );
  }

  handleClickOpen() {
    this.setState({ open: true });
  }

  handleClose() {
    this.setState({ open: false });
  }
}

export default withStyles(styles)(AccountDeleteDialog);
