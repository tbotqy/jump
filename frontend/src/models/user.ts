export interface User {
  id: number | string;
  name: string;
  screenName: string;
  avatarUrl: string;
  profileBannerUrl: string;
  protectedFlag: boolean;
  statusCount: string;
  followeeCount: string;
  statusesUpdatedAt: string;
  followeesUpdatedAt: string;
}

export interface TweetUser {
  name: string;
  screenName: string;
  avatarUrl: string;
}
