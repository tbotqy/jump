import React from "react";
import { withStyles } from "@material-ui/core/styles";
import {
  fetchUserByScreenName,
  fetchUserTweets,
  fetchUserSelectableDates,
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
import HeadProgressBar from "../components/HeadProgressBar";
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
  isFetching: boolean;
}

class UserPage extends React.Component<Props, State> {
  private onPopStateFunc: any
  state = {
    user: null,
    showMessage: false,
    selectableDates: [],
    message: "",
    isFetching: false
  };

  constructor(props: Props) {
    super(props);
    this.onPopStateFunc = this.onPathChange.bind(this);
    window.addEventListener("popstate", this.onPopStateFunc);
  }

  async componentDidMount() {
    this.setState({ selectableDates: [] });
    const { screenName, year, month, day } = this.props.match.params;
    const date = { year, month, day };

    const response = await fetchUserByScreenName(screenName);
    const user = response.data;
    this.setState({ user });

    const userId = user.id;
    await this.fetchTweets(userId, date as DateParams);
    this.fetchSelectableDates(userId);
  }

  componentDidUpdate(prevProps: Props) {
    if(this.props.match.url !== prevProps.match.url) {
      this.onPathChange();
    }
  }

  render() {
    return (
      <ApiErrorBoundary>
        <Head title={this.title()} />
        <HeadNav />
        <HeadProgressBar isFetching={this.state.isFetching} />
        {
          !this.state.user ? (
            <FullPageLoading />
          ) :
            (
              <>
                <Container maxWidth="md" className={this.props.classes.container} component="main">
                  <header>
                    <UserProfile user={this.state.user!} /> { /** TODO: Replace with ProfileUser */}
                  </header>
                  {this.state.showMessage ?
                    this.errorMessage() :
                    <Box pt={3} component="section">
                      <Grid container justify="space-between" alignItems="center" component="header">
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
    );
  }

  componentWillUnmount() {
    window.removeEventListener("popstate", this.onPopStateFunc);
  }

  async onPathChange(e?: Event) {
    if(e) e.preventDefault();
    const { year, month, day } = this.props.match.params;
    this.fetchTweets((this.state.user as any).id, { year, month, day } as DateParams);
  }

  async fetchTweets(userId: number, date: DateParams) {
    this.setState({isFetching: true});
    try {
      const response = await fetchUserTweets({ ...date, page: 1 }, userId);
      const tweets = response.data;

      if(tweets.length > 0) {
        this.props.setTweets(response.data);
      } else {
        this.setState({ showMessage: true, message: "ツイートが未登録です" });
      }
    } finally {
      this.setState({isFetching: false});
    }
  }

  async fetchSelectableDates(userId: number) {
    const response = await fetchUserSelectableDates(userId);
    this.setState({ selectableDates: response.data });
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
        <Typography component="h2" variant="h5" color="textSecondary">
          {timelinePageHeaderText(selectedYear, selectedMonth, selectedDay)}
        </Typography>
      );
    } else {
      return <></>;
    }
  }
}

export default withStyles(styles)(UserPage);
