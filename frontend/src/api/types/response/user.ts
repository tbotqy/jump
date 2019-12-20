export interface User {
  id: number;
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

export interface NewArrival {
  screenName: string;
  avatarUrl: string;
}

export interface TweetUser {
  name: string;
  screenName: string;
  avatarUrl: string;
}
