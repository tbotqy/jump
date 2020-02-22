import React from "react";
import {
  List,
  ListSubheader
} from "@material-ui/core";
import ExternalLink from "./ExternalLink";
import {
  GOOGLE_ADSENSE_POLICY_URL,
  GOOGLE_PRIVACY_POLICY_URL
} from "../../utils/externalUrls";
import ListItems from "./ListItems";

const firstTexts = [
  "当サービスがユーザーに提供する機能の実現にのみ利用します。",
  "ユーザーの操作により、好きな時に削除する事ができます。"
];

const secondTexts = [
  "当サービスでは、Google が提供する広告サービス「Google アドセンス」を利用しています。",
  "Google アドセンス では、ユーザーの興味に基づいた広告の表示をするため、当サイトや他サイトへのアクセスに関する情報（Cookie）を使用することがあります。",
  <>Cookie を無効にする設定および Google アドセンス に関する詳細は<ExternalLink href={ GOOGLE_ADSENSE_POLICY_URL }>こちら</ExternalLink>をご覧ください。</>,
];

const thirdTexts = [
  "当サービスでは、サイトの利用状況の分析と改善の目的で、Google が提供するアクセス解析ツール「Google アナリティクス」を利用しています。",
  "Google アナリティクス では、トラフィックデータの収集のために、Cookie を使用しています。",
  "このトラフィックデータには、個人を特定する情報は含まれません。",
  "Cookie を無効にすることでトラフィックデータの収集を拒否することができます。お使いのブラウザの設定をご確認ください。",
  <>Google の Cookie の利用に関する詳細は、<ExternalLink href={GOOGLE_PRIVACY_POLICY_URL}>こちら</ExternalLink>をご覧ください。</>
];

const PrivacyPolicyList: React.FC = () => (
  <List>
    <ListSubheader disableSticky>ユーザーのデータの取り扱いについて</ListSubheader>
    <ListItems texts={firstTexts} />

    <ListSubheader disableSticky>広告配信に際して</ListSubheader>
    <ListItems texts={secondTexts} />

    <ListSubheader disableSticky>アクセス解析に際して</ListSubheader>
    <ListItems texts={thirdTexts} />
  </List>
);

export default PrivacyPolicyList;
