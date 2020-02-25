import twitter, { AutoLinkOptions } from "twitter-text";
import { filterXSS } from "xss";
import { UrlEntity } from "../api";

const addNoOpenerToAnchors = (html: string): string => html.replace(/(<a.*?)>/g, '$1 rel="noopener">');

const autoLinkOptions: AutoLinkOptions = {
  targetBlank: true,
  suppressNoFollow: true,
  usernameIncludeSymbol: true
};

const filterXSSOptions = {
  whiteList: {
    a: ["href", "target", "rel"]
  }
};

export default function linkifyTweetText(text: string, urlEntities: UrlEntity[]): string {
  let html: string = twitter.autoLink(text, autoLinkOptions);
  urlEntities.forEach( urlEntity => {
    html = html.replace(`>${urlEntity.url}</a>`, `>${urlEntity.displayUrl}</a>`);
  });

  html = addNoOpenerToAnchors(html);

  html = filterXSS(html, filterXSSOptions);

  return html;
}
