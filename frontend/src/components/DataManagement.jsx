import React from "react";
import {
  List,
  ListItem,
  ListItemSecondaryAction,
  Typography,
  Container,
  Divider,
  CircularProgress
} from "@material-ui/core";
import {
  Textsms as TextsmsIcon,
  People as PeopleIcon
} from "@material-ui/icons";
import { withStyles } from "@material-ui/core/styles";
import {
  fetchUser,
  requestAdditionalTweetImport,
  requestFolloweeImport
} from "../utils/api";
import { PAGE_TITLE_DATA_MANAGEMENT } from "../utils/pageTitles";
import formatDateString from "../utils/formatDateString";
import HeadNav from "../containers/HeadNavContainer";
import CustomizedListItem from "../containers/CustomizedListItemContainer";
import AccountDeleteDialog from "../containers/AccountDeleteDialogContainer";
import Footer from "./Footer";
import ApiErrorBoundary from "../containers/ApiErrorBoundaryContainer";

const styles = theme => ({
  container: {
    minHeight: "100vh",
    paddingTop: theme.spacing(2)
  },
  typography: {
    marginTop: theme.spacing(3),
    marginBottom: theme.spacing(3)
  },
  deleteButtonListItem: {
    marginTop: theme.spacing(3)
  }
});

class DataManagement extends React.Component {
  componentDidMount() {
    fetchUser()
      .then( response => this.props.setUser(response.data) )
      .catch( error => this.props.setApiErrorCode(error.response.status) );

    document.title = PAGE_TITLE_DATA_MANAGEMENT;
  }

  render() {
    const { user, classes } = this.props;
    return (
      <React.Fragment>
        <HeadNav />
        <Container className={ classes.container }>
          <ApiErrorBoundary>
            <Typography variant="h4" className={ classes.typography }>
              データ管理
            </Typography>
            {
              user ? (
                <>
                  <List>
                    <CustomizedListItem
                      icon={ <TextsmsIcon /> }
                      headerText="ツイート"
                      numberText={ `${user.status_count} 件` }
                      updatedAt={ user.statuses_updated_at ? formatDateString(user.statuses_updated_at) : "-" }
                      apiFunc={ requestAdditionalTweetImport }
                    />
                    <CustomizedListItem
                      icon={ <PeopleIcon /> }
                      headerText="フォローリスト"
                      numberText={ `${user.followee_count} 件` }
                      updatedAt={ user.followees_updated_at ? formatDateString(user.followees_updated_at) : "-" }
                      apiFunc={ requestFolloweeImport }
                    />
                  </List>
                  <Divider />
                  <List>
                    <ListItem className={ classes.deleteButtonListItem }>
                      <ListItemSecondaryAction>
                        <AccountDeleteDialog />
                      </ListItemSecondaryAction>
                    </ListItem>
                  </List>
                </>
              ): <CircularProgress />
            }
          </ApiErrorBoundary>
        </Container>
        <Footer bgCaramel />
      </React.Fragment>
    );
  }
}

export default withStyles(styles)(DataManagement);
