import { DateParams } from "../api";

export type TimelineParams = DateParams & {
  screenName?: string;
}

export type UserPageParams = DateParams & {
  screenName: string;
}
