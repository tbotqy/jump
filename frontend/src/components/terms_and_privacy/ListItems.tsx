import React from "react";
import { ListItem, ListItemText } from "@material-ui/core";

interface Props {
  texts: (string | JSX.Element)[];
}

const ListItems = ({ texts }: Props) => (
  <>
    {
      texts.map((text, i) => (
        <ListItem key={i}>
          <ListItemText disableTypography>
            {text}
          </ListItemText>
        </ListItem>
      ))
    }
  </>
);

export default ListItems;
