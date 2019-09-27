import React from "react";
import TimelineSwitch from "./head_nav/TimelineSwitch";
import UserMenu from "../containers/UserMenuContainer";
import SignInButton from "./SignInButton";
import HeadAppBar from "./HeadAppBar";

const HeadNav = ({ isAuthenticated }) => (
  <HeadAppBar>
    {
      isAuthenticated ? (
        <>
          <TimelineSwitch />
          <UserMenu />
        </>
      ) : ( <SignInButton variant="contained" text="利用する" /> )
    }
  </HeadAppBar>
);

export default HeadNav;
