import React from "react";
import ReactDOM from "react-dom";

const headRoot = document.head;

const Head = ({ title, description }) => (
  ReactDOM.createPortal(
    <>
      <title>{ title }</title>
      <meta name="description" content={ description || title } />
    </>
    , headRoot
  )
);

export default Head;
