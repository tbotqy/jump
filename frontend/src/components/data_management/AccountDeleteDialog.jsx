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
  ListItemIcon,
  CircularProgress
} from "@material-ui/core";
import {
  Delete as DeleteIcon,
  Person as PersonIcon,
  VpnKey as VpnKeyIcon,
  Textsms as TextsmsIcon,
  People as PeopleIcon
} from "@material-ui/icons";
import api from "../../utils/api";
import getUserIdFromCookie from "../../utils/getUserIdFromCookie";
import { ROOT_PATH } from "../../utils/paths";

const styles = theme => ({
  byeMessageWrapper: {
    width: "100%",
    textAlign: "center"
  },
  buttonIcon: {
    marginRight: theme.spacing(1)
  }
});

const redirectInterval = 3000;

class AccountDeleteDialog extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      open:           false,
      disableButton:  false,
      showByeMessage: false
    };
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
            {
              this.state.showByeMessage ? (
                <div className={ this.props.classes.byeMessageWrapper }>
                  <p>完了！ご利用ありがとうございました。リダイレクトします...</p>
                </div>
              ) : (
                <>
                  { this.state.disableButton && <CircularProgress size={ 24 } /> }
                  <Button onClick={ this.handleClose.bind(this) } disabled={ this.state.disableButton } color="primary">
                    キャンセル
                  </Button>
                  <Button onClick={ this.handleDeleteButtonClick.bind(this) } disabled={ this.state.disableButton } color="secondary">
                    <DeleteIcon className={ this.props.classes.buttonIcon } />
                    実行
                  </Button>
                </>
              )
            }
          </DialogActions>
        </Dialog>
      </React.Fragment>
    );
  }

  MyListItem(icon, text) {
    return(
      <ListItem>
        <ListItemIcon>
          { icon }
        </ListItemIcon>
        <ListItemText secondary={ text } />
      </ListItem>
    );
  }

  handleClickOpen() {
    this.setState({ open: true });
  }

  handleClose() {
    this.setState({ open: false });
  }

  handleDeleteButtonClick() {
    this.setState({ disableButton: true });
    const userId = getUserIdFromCookie();
    api.delete(`/users/${userId}`)
      .then( () => {
        this.setState({ showByeMessage: true });
        setTimeout( () => { document.location.href = ROOT_PATH; }, redirectInterval );
      }).catch( error => this.props.setApiErrorCode(error.response.status) );
  }
}

export default withStyles(styles)(AccountDeleteDialog);
