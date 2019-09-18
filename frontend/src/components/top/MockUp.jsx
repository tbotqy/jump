import React from "react";
import MockUpImg from "./../../assets/mockup.png";

class MockUp extends React.Component {
  render() {
    return (
      <img alt="mockup" width="100%" src={ MockUpImg } decoding="async" />
    );
  }
}

export default MockUp;
