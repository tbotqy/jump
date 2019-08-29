import React from "react";
import TimelineSwitch from "./head_nav/TimelineSwitch";
import UserMenu from "../containers/userMenuContainer";
import SignInButton from "./SignInButton";
import HeadAppBar from "./HeadAppBar";

class HeadNav extends React.Component {
  render() {
    return (
      <HeadAppBar>
        {
          this.props.isAuthenticated ? (
            <>
              <TimelineSwitch />
              <UserMenu />
            </>
          ) : ( <SignInButton variant="contained" text="利用する" /> )
        }
      </HeadAppBar>
    );
  }
}

export default HeadNav;
