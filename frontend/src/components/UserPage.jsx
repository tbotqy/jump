import React from "react";
import { withStyles } from "@material-ui/core/styles";
import {
  fetchUserByScreenName,
  fetchUserTweets,
  fetchUserSelectableDates,
  API_ERROR_CODE_BAD_REQUEST,
  API_ERROR_CODE_UNAUTHORIZED,
  API_ERROR_CODE_NOT_FOUND
} from "../utils/api";
import timelineTitleText from "../utils/timelineTitleText";
import Head from "./Head";
import ApiErrorBoundary from "../containers/ApiErrorBoundaryContainer";
import HeadNav from "../containers/HeadNavContainer";
import HeadProgressBar from "../containers/HeadProgressBarContainer";
import UserProfile from "../components/UserProfile";
import DateSelectors from "../containers/DateSelectorsContainer";
import FullPageLoading from "./FullPageLoading";
import Footer from "./Footer";
import {
  Container,
  Grid,
  Typography,
  Box
} from "@material-ui/core";
import Ad            from "./Ad";
import TweetList     from "../containers/TweetListContainer";
import timelinePageHeaderText from "../utils/timelinePageHeaderText";
import TweetButton from "./TweetButton";
import scrollToTop   from "./../utils/scrollToTop";

const styles = theme => ({
  container: {
    paddingTop:   theme.spacing(3),
    paddingLeft:  theme.spacing(2),
    paddingRight: theme.spacing(2)
  },
  message: {
    paddingTop: theme.spacing(10),
    minHeight: "50vh"
  },
  tweetListContainer: {
    minHeight: "100vh"
  },
  dateSelectorContainer: {
    position: "sticky",
    bottom: theme.spacing(3)
  }
});

// to be passed to the child
const tweetsFetchFunc = userId => (year, month, day, page) => (
  fetchUserTweets(year, month, day, page, userId)
);

class UserPage extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      currentUser: null,
      showMessage: false,
      selectableDates: []
    };

    this.onPopStateFunc = this.onBackOrForwardButtonEvent.bind(this);
    window.addEventListener("popstate", this.onPopStateFunc);
  }

  async componentDidMount() {
    this.setState({ selectableDates: [] });
    const { screenName, year, month, day } = this.props.match.params;

    try {
      const response = await fetchUserByScreenName(screenName);
      const currentUser = response.data;
      this.setState({ currentUser });

      const userId = currentUser.id;
      this.fetchTweets(userId, year, month, day);
      this.fetchSelectableDates(userId);
    } catch (error) {
      this.props.setApiErrorCode(error.response.status);
    }
  }

  render() {
    return(
      <>
        <Head title={ this.title() } />
        <HeadNav />
        <ApiErrorBoundary>
          <HeadProgressBar />
          {
            !this.state.currentUser? (
              <FullPageLoading />
            ) : (
              <>
                <Container maxWidth="md" className={ this.props.classes.container }>
                  <UserProfile { ...this.state.currentUser } />
                  { this.state.showMessage ?
                    this.errorMessage() :
                    <Box pt={ 3 }>
                      <Grid container justify="space-between" alignItems="center">
                        <Grid item>
                          { this.headerText() }
                        </Grid>
                        <Grid item>
                          <TweetButton text={ document.title } buttonText={ "共有" } inTwitterBrandColor />
                        </Grid>
                      </Grid>
                      <Container>
                        <Box pt={ 2 } pb={ 2 }>
                          <Ad slot={ process.env.REACT_APP_AD_SLOT_ABOVE_TWEETS } />
                        </Box>
                      </Container>
                      <Grid container item justify="center" className={ this.props.classes.tweetListContainer }>
                        { !this.props.isFetching && <TweetList onLoadMoreTweetsFetchFunc={ tweetsFetchFunc(this.state.currentUser.id) } /> }
                      </Grid>
                    </Box>
                  }
                </Container>
                { this.state.selectableDates.length > 0 &&
                  <Box pr={ 2 } className={ this.props.classes.dateSelectorContainer }>
                    <DateSelectors
                      selectableDates={ this.state.selectableDates }
                      onSelectionChangeTweetsFetchFunc={ tweetsFetchFunc(this.state.currentUser.id) }
                    />
                  </Box>
                }
              </>
            )
          }
        </ApiErrorBoundary>
      </>
    );
  }

  componentWillUnmount() {
    window.removeEventListener("popstate", this.onPopStateFunc);
  }

  async onBackOrForwardButtonEvent(e) {
    e.preventDefault();
    const { year, month, day } = this.props.match.params;
    this.fetchTweets(this.state.currentUser.id, year, month, day);
    scrollToTop();
  }

  async fetchTweets(userId, year, month, day) {
    this.props.setIsFetching(true);
    try {
      const response = await fetchUserTweets(year, month, day, 1, userId);
      this.props.setTweets(response.data);
    } catch(error) {
      this.handleTweetDataApiError(error);
    } finally {
      this.props.setIsFetching(false);
    }
  }

  async fetchSelectableDates(userId) {
    try {
      const response = await fetchUserSelectableDates(userId);
      this.setState({ selectableDates: response.data });
    } catch(error) {
      this.handleTweetDataApiError(error);
    }
  }

  // TODO: consider to be given as param
  title() {
    const { screenName, year, month, day } = this.props.match.params;
    const userName = this.state.currentUser ? `${this.state.currentUser.name}（@${screenName}）` : `@${screenName}`;
    const leadText = year ? `${userName}のツイート` : `${userName}の過去のツイート`;
    return timelineTitleText(leadText, year, month, day);
  }

  handleTweetDataApiError(error) {
    switch(error.response.status) {
    case API_ERROR_CODE_BAD_REQUEST:
    case API_ERROR_CODE_UNAUTHORIZED:
      this.setState({ showMessage: true, message: "非公開ユーザーです" });
      break;
    case API_ERROR_CODE_NOT_FOUND:
      this.setState({ showMessage: true, message: "ツイートが未登録です" });
      break;
    default:
      this.props.setApiErrorCode(error.response.status);
      break;
    }
  }

  errorMessage() {
    return(
      <>
        <Grid container item justify="center" className={ this.props.classes.message }>
          <Typography variant="h4" component="p" color="textSecondary">{ this.state.message }</Typography>
        </Grid>
        <Footer />
      </>
    );
  }

  headerText() {
    const { selectedYear, selectedMonth, selectedDay } = this.props;
    if( selectedYear && selectedMonth && selectedDay ) {
      return (
        <Typography component="h1" variant="h5" color="textSecondary">
          { timelinePageHeaderText(selectedYear, selectedMonth, selectedDay) }
        </Typography>
      );
    } else {
      return <></>;
    }
  }
}

export default withStyles(styles)(UserPage);
