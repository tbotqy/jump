import dateText from "./dateText";
const serviceName = process.env.REACT_APP_SERVICE_NAME;

export default function timelineTitleText(timelineName, year, month, day) {
  if(!timelineName) {
    throw new Error("timelineName is not given.");
  }

  if(!year && !month && !day) {
    return `${timelineName} - ${serviceName}`;
  }

  return `${dateText(year, month, day)}の${timelineName} - ${process.env.REACT_APP_SERVICE_NAME}`;
}
