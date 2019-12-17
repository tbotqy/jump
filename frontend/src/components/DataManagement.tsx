import React from "react";
import {
  List,
  ListItem,
  ListItemSecondaryAction,
  Typography,
  Container,
  Divider,
  CircularProgress,
  createStyles,
  Theme,
  WithStyles
} from "@material-ui/core";
import {
  Textsms as TextsmsIcon,
  People as PeopleIcon
} from "@material-ui/icons";
import { withStyles } from "@material-ui/core/styles";
import {
  fetchAuthenticatedUser,
  requestAdditionalTweetImport,
  requestFolloweeImport
} from "../utils/api";
import { PAGE_TITLE_DATA_MANAGEMENT } from "../utils/pageHead";
import formatDateString from "../utils/formatDateString";
import HeadNav from "../containers/HeadNavContainer";
import CustomizedListItem from "../containers/CustomizedListItemContainer";
import AccountDeleteDialog from "../containers/AccountDeleteDialogContainer";
import Footer from "./Footer";
import ApiErrorBoundary from "../containers/ApiErrorBoundaryContainer";
import Head from "./Head";
import { User } from "../models/user";

const styles = (theme: Theme) => (
  createStyles({
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
  })
);

interface Props extends WithStyles<typeof styles>{
  user?: User;
  setUser: (user: User) => void;
  setApiErrorCode: (code: number) => void;
}

class DataManagement extends React.Component<Props> {
  async componentDidMount() {
    try {
      const response = await fetchAuthenticatedUser();
      this.props.setUser(response.data);
    } catch(error) {
      this.props.setApiErrorCode(error.response.status);
    }
  }

  render() {
    const { user, classes } = this.props;
    return (
      <>
        <Head title={ PAGE_TITLE_DATA_MANAGEMENT } />
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
                      numberText={ `${user.statusCount} 件` }
                      updatedAt={ user.statusesUpdatedAt ? formatDateString(user.statusesUpdatedAt) : "-" }
                      apiFunc={ requestAdditionalTweetImport }
                    />
                    <CustomizedListItem
                      icon={ <PeopleIcon /> }
                      headerText="フォローリスト"
                      numberText={ `${user.followeeCount} 件` }
                      updatedAt={ user.followeesUpdatedAt ? formatDateString(user.followeesUpdatedAt) : "-" }
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
      </>
    );
  }
}

export default withStyles(styles)(DataManagement);
