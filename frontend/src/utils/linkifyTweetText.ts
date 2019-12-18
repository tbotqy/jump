import twitter, { AutoLinkOptions } from "twitter-text";
import { filterXSS } from "xss";
import { UrlEntity } from "../models/tweet";


const autoLinkOptions: AutoLinkOptions = {
  targetBlank: true,
  usernameIncludeSymbol: true
};

export default function linkifyTweetText(text: string, urlEntities: UrlEntity[]): string {
  let html: string = twitter.autoLink(text, autoLinkOptions);
  urlEntities.forEach( urlEntity => {
    html = html.replace(`>${urlEntity.url}</a>`, `>${urlEntity.displayUrl}</a>`);
  });
  html = filterXSS(html);
  return html;
}
