import twitter, { AutoLinkOptions } from "twitter-text";
import { filterXSS } from "xss";
import { UrlEntity } from "../api";


const autoLinkOptions: AutoLinkOptions = {
  targetBlank: true,
  suppressNoFollow: true,
  usernameIncludeSymbol: true
};

export default function linkifyTweetText(text: string, urlEntities: UrlEntity[]): string {
  let html: string = twitter.autoLink(text, autoLinkOptions);
  urlEntities.forEach( urlEntity => {
    html = html.replace(`>${urlEntity.url}</a>`, ` rel="noopener">${urlEntity.displayUrl}</a>`);
  });

  html = filterXSS(html, {
    whiteList: {
      a: ["href", "target", "rel"]
    }
  });

  return html;
}
