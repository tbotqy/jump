import React from "react";
import {
  Grid,
  Typography,
  Button,
  LinearProgress,
  CircularProgress,
  Fab
} from "@material-ui/core";
import green from "@material-ui/core/colors/green";
import CheckIcon from "@material-ui/icons/Check";
import TweetEmbed from "react-tweet-embed";
import HeadNav from "./HeadNav";
import Footer from "./Footer";

class Import extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      buttonHasBeenClicked: false,
      completed:            false,
      buttonText:           "開始",
      circularDisplayValue: "none",
      progress:             0
    };
  }

  render() {
    return (
      <React.Fragment>
        <HeadNav />
        <Grid container direction="column" alignItems="center" style={ { padding: "24px" } }>
          <Grid item style={ { paddingTop: "48px" } }>
            <Typography variant="h5" component="h1">@{ this.props.screenName } のツイートを取り込む</Typography>
          </Grid>
          <Grid item style={ { paddingTop: "48px" } }>
            <Button
              variant="contained"
              color="primary"
              disabled={ this.state.buttonHasBeenClicked }
              onClick={ this.handleClick.bind(this) }
            >
              { this.state.buttonText }
            </Button>
          </Grid>
          <Grid item style={ { paddingTop: "48px", width: "100%" } }>
            <Grid item align="right" style={ { paddingBottom: "20px", minHeight: "80px" } }>
              { this.state.buttonHasBeenClicked && this.state.progress < 100 && <CircularProgress style={ { display: this.state.circularDisplayValue } } /> }
              { this.state.progress === 100 && <Fab style={ { backgroundColor: green["500"], color: "white" } } ><CheckIcon /></Fab> }
            </Grid>
            <Grid item>
              <LinearProgress variant="determinate" value={ this.state.progress } />
            </Grid>
          </Grid>
          <Grid item style={ { marginTop: "48px", minHeight: "500px" } }>
            { this.state.importedTweetId && <TweetEmbed id={ this.state.importedTweetId } options={ { width: 300, align: "center" } } /> }
          </Grid>
        </Grid>
        <Footer bgCaramel />
      </React.Fragment>
    );
  }

  handleClick() {
    if ( this.state.buttonHasBeenClicked ) return;

    this.setState({
      buttonText: "取り込み中",
      circularDisplayValue: "block",
      buttonHasBeenClicked: true,
      importedTweetId: "692527862369357824"
    });

    const interval = setInterval( () => {
      if ( this.state.progress < 100 ) {
        this.setState( {
          progress: this.state.progress + 25,
          importedTweetId: "692527862369357824"
        });
      } else {
        clearInterval(interval);
        this.setState({
          circularDisplayValue: "none",
          buttonText: "完了！リダイレクトします..."
        });
        setTimeout( () => { document.location.href = "/user_timeline"; }, 3000 );
      }
    }, 2000 );
  }
}

export default Import;
