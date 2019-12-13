import React from "react";
import ReactDOM from "react-dom";

const headRoot = document.head;

interface Props {
  title: string;
  description?: string;
}

const Head = ({ title, description }: Props): React.ReactPortal => (
  ReactDOM.createPortal(
    <>
      <title>{ title }</title>
      <meta name="description" content={ description || title } />
    </>
    , headRoot
  )
);

export default Head;
