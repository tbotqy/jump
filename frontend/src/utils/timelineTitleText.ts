import dateText from "./dateText";
const serviceName = process.env.REACT_APP_SERVICE_NAME;

export default function timelineTitleText(
  timelineName: string,
  year: string,
  month: string,
  day: string
): string {
  if(!timelineName) {
    throw new Error("timelineName is not given.");
  }

  if(!year && !month && !day) {
    return `${timelineName} - ${serviceName}`;
  }

  return `${dateText(year, month, day)}の${timelineName} - ${process.env.REACT_APP_SERVICE_NAME}`;
}
