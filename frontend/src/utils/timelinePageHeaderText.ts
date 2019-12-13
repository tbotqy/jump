import dateText from "./dateText";

function timelinePageHeaderText(year: string, month: string, day: string, screenName?: string): string {
  let ret = `${dateText({ year, month, day })}の`;

  if(screenName) {
    ret += `@${screenName}の`;
  }

  return `${ret}ツイート`;
}

export default timelinePageHeaderText;
