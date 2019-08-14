const twitter = require("twitter-text");
const xss     = require("xss");

export default function linkifyTweetText(text, urlEntities) {
  let html = twitter.autoLink(text);
  urlEntities.forEach( urlEntity => {
    html = html.replace(`>${urlEntity.url}</a>`, `>${urlEntity.display_url}</a>`);
  });
  html = xss(html);
  return html;
}
