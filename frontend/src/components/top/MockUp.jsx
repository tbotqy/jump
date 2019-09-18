import React from "react";
import { withStyles } from "@material-ui/core/styles";
import MockUpImg from "./../../assets/mockup.png";

const styles = () => ({
  img: {
    "width":    "auto",
    "height":   "auto",
    "maxWidth": "100%",
    "maxHeight":"100%"
  }
})

class MockUp extends React.Component {
  render() {
    return (
      <img alt="mockup" src={ MockUpImg } decoding="async" className={ this.props.classes.img } />
    );
  }
}

export default withStyles(styles)(MockUp);
