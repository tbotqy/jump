import dateText from "./dateText";
import { DateParams } from "./api";
const serviceName = process.env.REACT_APP_SERVICE_NAME;

export default function timelineTitleText(timelineName: string, { year, month, day }: DateParams): string {
  if(!timelineName) {
    throw new Error("timelineName is not given.");
  }

  if(!year && !month && !day) {
    return `${timelineName} - ${serviceName}`;
  }

  return `${dateText({ year, month, day } as DateParams)}の${timelineName} - ${process.env.REACT_APP_SERVICE_NAME}`;
}
