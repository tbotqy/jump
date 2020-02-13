import React from "react";
import { withStyles } from "@material-ui/core/styles";
import {
  fetchUserByScreenName,
  fetchUserTweets,
  fetchUserSelectableDates,
  API_ERROR_CODE_UNAUTHORIZED,
  API_ERROR_CODE_NOT_FOUND,
  DateParams,
  PaginatableDateParams,
  Tweet,
  User,
  TweetDate
} from "../api";
import timelineTitleText from "../utils/timelineTitleText";
import Head from "../components/Head";
import ApiErrorBoundary from "../containers/ApiErrorBoundaryContainer";
import HeadNav from "../containers/HeadNavContainer";
import HeadProgressBar from "../containers/HeadProgressBarContainer";
import UserProfile from "../components/UserProfile";
import DateSelectors from "../containers/DateSelectorsContainer";
import FullPageLoading from "../components/FullPageLoading";
import Footer from "../components/Footer";
import {
  Container,
  Grid,
  Typography,
  Box,
  Theme,
  createStyles,
  WithStyles
} from "@material-ui/core";
import TweetList from "../containers/TweetListContainer";
import timelinePageHeaderText from "../utils/timelinePageHeaderText";
import ShareButton from "../components/ShareButton";
import { RouteComponentProps } from "react-router-dom";
import { UserPageParams } from "../components/types";
import { AxiosError } from "axios";
import { USER_PAGE_PATH } from "../utils/paths";

const styles = (theme: Theme) => (
  createStyles({
    container: {
      paddingTop: theme.spacing(3),
      paddingLeft: theme.spacing(2),
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
  })
);

interface Props extends RouteComponentProps<UserPageParams>, WithStyles<typeof styles> {
  setApiErrorCode: (code: number) => void;
  setIsFetching: (flag: boolean) => void;
  setTweets: (tweets: Tweet[]) => void;
  tweets: Tweet[];
  selectedYear?: string;
  selectedMonth?: string;
  selectedDay?: string;
}

interface State {
  user: User | null;
  showMessage: boolean;
  selectableDates: TweetDate[];
  message: string;
}

class UserPage extends React.Component<Props, State> {
  private onPopStateFunc: any
  state = {
    user: null,
    showMessage: false,
    selectableDates: [],
    message: ""
  };

  constructor(props: Props) {
    super(props);
    this.onPopStateFunc = this.onBackOrForwardButtonEvent.bind(this);
    window.addEventListener("popstate", this.onPopStateFunc);
  }

  async componentDidMount() {
    this.setState({ selectableDates: [] });
    const { screenName, year, month, day } = this.props.match.params;
    const date = { year, month, day };

    try {
      const response = await fetchUserByScreenName(screenName);
      const user = response.data;
      this.setState({ user });

      const userId = user.id;
      this.fetchTweets(userId, date as DateParams);
      this.fetchSelectableDates(userId);
    } catch (error) {
      this.props.setApiErrorCode(error.response.status);
    }
  }

  render() {
    return (
      <>
        <Head title={this.title()} />
        <HeadNav />
        <ApiErrorBoundary>
          <HeadProgressBar />
          {
            !this.state.user ? (
              <FullPageLoading />
            ) :
              (
                <>
                  <Container maxWidth="md" className={this.props.classes.container}>
                    <UserProfile user={this.state.user!} /> { /** TODO: Replace with ProfileUser */}
                    {this.state.showMessage ?
                      this.errorMessage() :
                      <Box pt={3}>
                        <Grid container justify="space-between" alignItems="center">
                          <Grid item>
                            {this.headerText()}
                          </Grid>
                          <Grid item>
                            <ShareButton inTwitterBrandColor />
                          </Grid>
                        </Grid>
                        <Grid container item justify="center" className={this.props.classes.tweetListContainer}>
                          {this.props.tweets.length > 0 && <TweetList onLoadMoreTweetsFetchFunc={this.tweetsFetchFunc} />}
                        </Grid>
                      </Box>
                    }
                  </Container>
                  {this.state.selectableDates.length > 0 &&
                    <Box pr={2} className={this.props.classes.dateSelectorContainer}>
                      <DateSelectors
                        selectableDates={this.state.selectableDates}
                        onSelectionChangeTweetsFetchFunc={this.tweetsFetchFunc}
                        basePath={`${USER_PAGE_PATH}/${this.props.match.params.screenName}`}
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

  async onBackOrForwardButtonEvent(e: Event) {
    e.preventDefault();
    const { year, month, day } = this.props.match.params;
    this.fetchTweets((this.state.user as any).id, { year, month, day } as DateParams);
  }

  async fetchTweets(userId: number, date: DateParams) {
    this.props.setIsFetching(true);
    try {
      const response = await fetchUserTweets({ ...date, page: 1 }, userId);
      this.props.setTweets(response.data);
    } catch (error) {
      this.handleTweetDataApiError(error);
    } finally {
      this.props.setIsFetching(false);
    }
  }

  async fetchSelectableDates(userId: number) {
    try {
      const response = await fetchUserSelectableDates(userId);
      this.setState({ selectableDates: response.data });
    } catch (error) {
      this.handleTweetDataApiError(error);
    }
  }

  // to be passed to the child
  tweetsFetchFunc = (params: PaginatableDateParams) => {
    const userId: number = (this.state.user as any).id;
    return fetchUserTweets(params, userId);
  }


  // TODO: consider to be given as param
  title() {
    const { screenName, year, month, day } = this.props.match.params;
    const userName = this.state.user ? `${(this.state.user as any).name}（@${screenName}）` : `@${screenName}`;
    const leadText = year ? `${userName}のツイート` : `${userName}の過去のツイート`;
    const date = { year, month, day } as DateParams;
    return timelineTitleText(leadText, date);
  }

  handleTweetDataApiError(error: AxiosError) {
    switch (error.response!.status) {
      case API_ERROR_CODE_UNAUTHORIZED:
        this.setState({ showMessage: true, message: "非公開ユーザーです" });
        break;
      case API_ERROR_CODE_NOT_FOUND:
        this.setState({ showMessage: true, message: "ツイートが未登録です" });
        break;
      default:
        this.props.setApiErrorCode(error.response!.status);
        break;
    }
  }

  errorMessage() {
    return (
      <>
        <Grid container item justify="center" className={this.props.classes.message}>
          <Typography variant="h4" component="p" color="textSecondary">{this.state.message}</Typography>
        </Grid>
        <Footer />
      </>
    );
  }

  headerText() {
    const { selectedYear, selectedMonth, selectedDay } = this.props;
    if (selectedYear && selectedMonth && selectedDay) {
      return (
        <Typography component="h1" variant="h5" color="textSecondary">
          {timelinePageHeaderText(selectedYear, selectedMonth, selectedDay)}
        </Typography>
      );
    } else {
      return <></>;
    }
  }
}

export default withStyles(styles)(UserPage);
