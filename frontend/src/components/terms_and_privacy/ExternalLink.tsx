import React from "react";
import {
  Link,
  createStyles,
  WithStyles
} from "@material-ui/core";
import { withStyles } from "@material-ui/core/styles";
import LaunchIcon from "@material-ui/icons/Launch";

const styles = createStyles({
  icon: {
    position: "relative",
    top: "2px"
  }
});

interface Props extends WithStyles<typeof styles> {
  children: React.ReactNode;
  href: string;
}

const ExternalLink: React.FC<Props> = ({ children, href, classes }) => (
  <Link href={ href } target="_blank" rel="noopener">
    <>{ children } <LaunchIcon fontSize="inherit" className={ classes.icon } /></>
  </Link>
);

export default withStyles(styles)(ExternalLink);
