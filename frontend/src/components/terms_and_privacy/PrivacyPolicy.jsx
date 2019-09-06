import React from "react";
import {
  CardContent,
  Typography,
  List,
  ListItem,
  ListItemText,
  ListSubheader,
  Link
} from "@material-ui/core";
import { withStyles } from "@material-ui/core/styles";
import LaunchIcon from "@material-ui/icons/Launch";
import {
  GOOGLE_ADSENSE_POLICY_URL,
  GOOGLE_PRIVACY_POLICY_URL
} from "../../utils/externalUrls";

const styles = () => ({
  icon: {
    position: "relative",
    top: "2px"
  }
});

const PrivacyPolicy = props => {
  const ExternalLink = ({ children, href }) => (
    <Link href={ href } target="_blank" rel="noopener">
      <>{ children } <LaunchIcon fontSize="inherit" className={ props.classes.icon } /></>
    </Link>
  );

  return(
    <CardContent>
      <Typography gutterBottom variant="h4">
        プライバシーポリシー
      </Typography>
      <List>
        <ListSubheader disableSticky>ユーザーのデータの取り扱いについて</ListSubheader>
        <ListItem>
          <ListItemText>
            当サービスがユーザーに提供する機能の実現にのみ利用します。
          </ListItemText>
        </ListItem>
        <ListItem>
          <ListItemText>
            ユーザーの操作により、好きな時に削除する事ができます。
          </ListItemText>
        </ListItem>
        <ListSubheader disableSticky>広告配信に際して</ListSubheader>
        <ListItem>
          <ListItemText>
            当サービスでは、Google が提供する広告サービス「Google アドセンス」を利用しています。
          </ListItemText>
        </ListItem>
        <ListItem>
          <ListItemText>
            Google アドセンス では、ユーザーの興味に基づいた広告の表示をするため、当サイトや他サイトへのアクセスに関する情報
            （Cookie）を使用することがあります。
          </ListItemText>
        </ListItem>
        <ListItem>
          <ListItemText>
            Cookie を無効にする設定および Google アドセンス に関する詳細は
            <ExternalLink href={ GOOGLE_ADSENSE_POLICY_URL }>こちら</ExternalLink>
            をご覧ください。
          </ListItemText>
        </ListItem>
        <ListSubheader disableSticky>アクセス解析に際して</ListSubheader>
        <ListItem>
          <ListItemText>
            当サービスでは、サイトの利用状況の分析と改善の目的で、Google が提供するアクセス解析ツール「Google アナリティクス」を利用しています。
          </ListItemText>
        </ListItem>
        <ListItem>
          <ListItemText>
            Google アナリティクス では、トラフィックデータの収集のために、Cookie を使用しています。
          </ListItemText>
        </ListItem>
        <ListItem>
          <ListItemText>
            このトラフィックデータには、個人を特定する情報は含まれません。
          </ListItemText>
        </ListItem>
        <ListItem>
          <ListItemText>
            Cookie を無効にすることでトラフィックデータの収集を拒否することができます。お使いのブラウザの設定をご確認ください。
          </ListItemText>
        </ListItem>
        <ListItem>
          <ListItemText>
            Google の Cookie の利用に関する詳細は、
            <ExternalLink href={ GOOGLE_PRIVACY_POLICY_URL }>こちら</ExternalLink>
            をご覧ください。
          </ListItemText>
        </ListItem>
      </List>
    </CardContent>
  );
};

export default withStyles(styles)(PrivacyPolicy);
