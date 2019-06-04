import React from "react";
import { withStyles } from "@material-ui/core/styles";
import {
  CardHeader,
  CardContent,
  Typography,
  Chip,
  Divider,
  Button
} from "@material-ui/core";
import grey from "@material-ui/core/colors/grey";
import Box from "@material-ui/core/Box";

const styles = theme => ({
  box: {
    backgroundColor: "white"
  },
  cardHeaderText: {
    color: grey["700"]
  },
  cardTextWrapper: {
    paddingBottom: 0
  },
  cardText: {
    lineHeight: 3,
    color: theme.palette.text.secondary
  }
});

class TopCard extends React.Component {
  constructor(props) {
    super(props);

    this.buttonStyle = {
      backgroundColor: props.buttonColor,
      color: "white",
      textTransform: "none"
    };
  }
  render() {
    return (
      <Box className={ this.props.classes.box }>
        <CardHeader align="center" title={ this.props.headerText } titleTypographyProps={ { className: this.props.classes.cardHeaderText } } />
        <Divider />
        <CardContent className={ this.props.classes.cardTextWrapper }>
          <Typography align="center" variant="subheading" component="p" className={ this.props.classes.cardText }>
            { this.props.contentText }
          </Typography>
        </CardContent>
        <CardContent align="center">
          <Chip label={ this.props.chipText } />
        </CardContent>
        <CardContent>
          <Button href={ this.props.buttonHref } fullWidth variant="contained" size="large" style={ this.buttonStyle }>
            { this.props.buttonText }
          </Button>
        </CardContent>
      </Box>
    );
  }
}

export default withStyles(styles)(TopCard);
