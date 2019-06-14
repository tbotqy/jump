import React from "react";
import {
  CardContent,
  Typography,
  List,
  ListItem,
  ListItemText,
  Link
} from "@material-ui/core";

class TermsOfService extends React.Component {
  constructor(props) {
    super(props);
    this.texts = [
      "このアプリケーションでは、Twitter が提供している仕組みを利用して、ユーザーが Twitter で保有しているデータを取得・保存します。",
      <>保存されたあなたのツイートは、アプリケーション内の<Link href="/public_timeline">パブリックタイムライン</Link>に表示され、誰でも見ることが可能となります。</>,
      "アプリの性質上、Twitterアカウントに鍵をかけている方は登録ができないつくりになっています。",
      "取得できるツイートの件数は、最新のツイートから最大3,200件までです。",
      "当サービスは、表示データの正確性確保に努めますが、これを保証するものではありません。",
      "当サービスは、当サービスを利用することにより発生したいかなる損害も、責任を負わないものとします。",
      "当サービスの提供は予告無く停止・変更される場合がある事を予めご了承ください。"
    ];
  }

  render() {
    return(
      <CardContent>
        <Typography gutterBottom variant="h4">
          利用規約
        </Typography>
        <List>
          { this.texts.map( (text, i) => (
            <ListItem key={ i }>
              <ListItemText>
                { text }
              </ListItemText>
            </ListItem>
          )) }
        </List>
      </CardContent>
    );
  }
}

export default TermsOfService;