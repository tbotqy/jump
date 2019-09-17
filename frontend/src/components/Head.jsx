import React from "react";
import ReactDOM from "react-dom";

const headRoot = document.head;
const siteName = process.env.REACT_APP_SERVICE_NAME;
const userName = process.env.REACT_APP_ADMIN_TWITTER_SCREEN_NAME;

const Head = ({ title, description = title, type = "article" }) => (
  ReactDOM.createPortal(
    <>
      <title>{ title }</title>
      <meta name="description" content={ description } />
      <meta name="twitter:card" content="summary_large_image" />
      <meta name="twitter:site" content={ `@${userName}` } />
      <meta property="og:site_name" content={ siteName } />
      <meta property="og:type" content={ type } />
      <meta property="og:url" content={ document.location.href } />
      <meta property="og:title" content={ title } />
      <meta property="og:description" content={ description } />
      <meta property="og:image" content="https://user-images.githubusercontent.com/140096/65042611-27585b80-d994-11e9-8250-fd6db31b2165.png" />
    </>
    , headRoot
  )
);

export default Head;
