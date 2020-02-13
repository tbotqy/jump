import React from "react";
import { withRouter, RouteComponentProps } from "react-router-dom";
import { withStyles } from "@material-ui/core/styles";
import {
  Container,
  Box,
  Grid,
  Typography,
  Theme,
  createStyles,
  WithStyles
} from "@material-ui/core";
import Head from "./Head";
import HeadNav from "../containers/HeadNavContainer";
import HeadProgressBar from "../containers/HeadProgressBarContainer";
import DateSelectors from "../containers/DateSelectorsContainer";
import ApiErrorBoundary from "../containers/ApiErrorBoundaryContainer";
import timelineTitleText from "../utils/timelineTitleText";
import timelinePageHeaderText from "../utils/timelinePageHeaderText";
import TweetList from "../containers/TweetListContainer";
import ShareButton from "./ShareButton";
import { TimelineParams } from "./types";
import {
  Tweet,
  TweetDate,
  DateParams
} from "../api";
import { AxiosPromise } from "axios";

const styles = (theme: Theme) => (
  createStyles({
    container: {
      paddingTop: theme.spacing(3),
      paddingLeft: theme.spacing(2),
      paddingRight: theme.spacing(2)
    },
    dateSelectorContainer: {
      position: "sticky",
      bottom: theme.spacing(3)
    },
    tweetListContainer: {
      minHeight: "100vh"
    }
  })
);

// TODO: define DRYly
interface DefaultProps {
  showShareButton: boolean;
}

interface Props extends DefaultProps, RouteComponentProps<TimelineParams>, WithStyles<typeof styles> {
  tweets: Tweet[];
  tweetsFetchFunc: (params: DateParams) => AxiosPromise;
  basePath: string;
  setTweets: (tweets: Tweet[]) => void;
  setApiErrorCode: (code: number) => void;
  setIsFetching: (flag: boolean) => void;
  selectableDatesFetchFunc: () => AxiosPromise;
  selectedYear?: string;
  selectedMonth?: string;
  selectedDay?: string;
  timelineName: string;
}

interface State {
  selectableDates: TweetDate[];
}

class TimelineBase extends React.Component<Props, State> {
  private onPopStateFunc: any
  state = { selectableDates: [] }

  constructor(props: Props) {
    super(props);
    this.onPopStateFunc = this.onBackOrForwardButtonEvent.bind(this);
    window.addEventListener("popstate", this.onPopStateFunc);
  }

  static defaultProps: DefaultProps = {
    showShareButton: false
  }

  componentDidMount() {
    this.setState({ selectableDates: [] });
    this.fetchTweets(this.props.match.params);
    this.fetchSelectableDates();
  }

  componentDidUpdate(prevProps: Props) {
    if (this.props.match.url !== prevProps.match.url) {
      this.fetchTweets(this.props.match.params);
    }
  }

  render() {
    return (
      <>
        <Head title={this.title()} />
        <HeadNav />
        <ApiErrorBoundary>
          <HeadProgressBar />
          <Container maxWidth="md" className={this.props.classes.container}>
            <Grid container justify="space-between" alignItems="center">
              <Grid item>
                {this.headerText()}
              </Grid>
              <Grid item>
                {this.props.showShareButton && <ShareButton inTwitterBrandColor />}
              </Grid>
            </Grid>
            <Grid container item justify="center" className={this.props.classes.tweetListContainer}>
              {this.props.tweets.length > 0 && <TweetList onLoadMoreTweetsFetchFunc={this.props.tweetsFetchFunc} />}
            </Grid>
          </Container>
          {this.state.selectableDates.length > 0 &&
            <Box pr={2} className={this.props.classes.dateSelectorContainer}>
              <DateSelectors
                selectableDates={this.state.selectableDates}
                onSelectionChangeTweetsFetchFunc={this.props.tweetsFetchFunc}
                basePath={this.props.basePath}
              />
            </Box>
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
    this.fetchTweets(this.props.match.params);
  }

  async fetchTweets(params: DateParams) {
    this.props.setIsFetching(true);
    try {
      const response = await this.props.tweetsFetchFunc(params);
      this.props.setTweets(response.data);
    } catch (error) {
      error.response && this.props.setApiErrorCode(error.response.status);
    } finally {
      this.props.setIsFetching(false);
    }
  }

  async fetchSelectableDates() {
    try {
      const response = await this.props.selectableDatesFetchFunc();
      this.setState({ selectableDates: response.data });
    } catch (error) {
      error.response && this.props.setApiErrorCode(error.response.status);
    }
  }

  // TODO: consider to be given as param
  title() {
    const { year, month, day } = this.props.match.params;
    const date = { year, month, day } as DateParams;
    return timelineTitleText(this.props.timelineName, date);
  }

  headerText() {
    const { selectedYear, selectedMonth, selectedDay } = this.props;
    const { screenName } = this.props.match.params;
    if (selectedYear && selectedMonth && selectedDay) {
      return (
        <Typography component="h1" variant="h5" color="textSecondary">
          {timelinePageHeaderText(selectedYear, selectedMonth, selectedDay, screenName)}
        </Typography>
      );
    } else {
      return <></>;
    }
  }
}

export default withRouter(withStyles(styles)(TimelineBase));
