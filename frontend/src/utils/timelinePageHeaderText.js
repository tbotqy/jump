import dateText from "./dateText";

function timelinePageHeaderText(year, month, day, screenName) {
  let ret = `${dateText(year, month, day)}の`;

  if(screenName) {
    ret += `@${screenName}の`;
  }

  return `${ret}ツイート`;
}

export default timelinePageHeaderText;
