import React from "react";
import { Link as RouterLink } from "react-router-dom";
import {
  Grid,
  Link,
  Typography,
  Box
} from "@material-ui/core";
import { TERMS_AND_PRIVACY_PATH } from "../utils/paths";
import { CARAMEL_COLOR } from "../utils/colors";
import ShareButton from "./ShareButton";

const adminTwitterScreenName = process.env.REACT_APP_ADMIN_TWITTER_SCREEN_NAME;

interface Props {
  bgCaramel?: boolean;
}

const Footer: React.FC<Props> = ({ bgCaramel }) => {
  const backgroundColor = bgCaramel ? CARAMEL_COLOR : "white";

  return (
    <Box pt={4} pb={4} style={ { backgroundColor } } component="footer">
      <Grid container direction="column" alignItems="center" justify="center" spacing={2} style={{width:"100%"}}>
        <Grid item>
          <ShareButton />
        </Grid>
        <Grid item>
          <Typography color="textSecondary">
            <Link
              color="inherit"
              component={ RouterLink }
              to={ TERMS_AND_PRIVACY_PATH }
            >
              利用規約・プライバシーポリシー
            </Link>
          </Typography>
        </Grid>
        <Grid item>
          <Grid container justify="center" spacing={2}>
            <Grid item>
              <Typography color="textSecondary">© 2012-{ new Date().getFullYear() }</Typography>
            </Grid>
            <Grid item>
              <Typography color="textSecondary">
                <Link color="inherit" href={ `//twitter.com/${adminTwitterScreenName}` } target="_blank" rel="noopener">
                  {`@${adminTwitterScreenName}`}
                </Link>
              </Typography>
            </Grid>
          </Grid>
        </Grid>
      </Grid>
    </Box>
  );
};

export default Footer;
