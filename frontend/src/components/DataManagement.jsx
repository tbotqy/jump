import React from "react";
import {
  Card,
  List,
  ListItem,
  ListItemSecondaryAction,
  Typography,
  Container,
  Divider,
  CardContent
} from "@material-ui/core";
import {
  Textsms as TextsmsIcon,
  People as PeopleIcon
} from "@material-ui/icons";
import { withStyles } from "@material-ui/core/styles";
import HeadNav from "./HeadNav";
import CustomizedListItem from "./data_management/CustomizedListItem";
import AccountDeleteDialog from "./data_management/AccountDeleteDialog";
import Footer from "./Footer";
import ApiErrorBoundary from "../containers/ApiErrorBoundaryContainer";

const styles = theme => ({
  container: {
    minHeight: "100vh"
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
  render() {
    return (
      <React.Fragment>
        <HeadNav />
        <Container className={ this.props.classes.container }>
          <ApiErrorBoundary>
            <Typography variant="h4" className={ this.props.classes.typography }>
              データ管理
            </Typography>

            <Card>
              <CardContent>
                <List>
                  <CustomizedListItem
                    icon={ <TextsmsIcon /> }
                    headerText="ツイート"
                    numberText="3,200件"
                    updatedAt="2019/5/10 - 23:20"
                    onButtonClick={ () => {} }
                  />
                  <CustomizedListItem
                    icon={ <PeopleIcon /> }
                    headerText="フォローリスト"
                    numberText="200件"
                    updatedAt="2019/5/10 - 23:20"
                    onButtonClick={ () => {} }
                  />
                </List>
                <Divider />
                <List>
                  <ListItem className={ this.props.classes.deleteButtonListItem }>
                    <ListItemSecondaryAction>
                      <AccountDeleteDialog />
                    </ListItemSecondaryAction>
                  </ListItem>
                </List>
              </CardContent>
            </Card>
          </ApiErrorBoundary>
        </Container>
        <Footer bgCaramel />
      </React.Fragment>
    );
  }
}

export default withStyles(styles)(DataManagement);
