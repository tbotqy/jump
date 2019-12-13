export interface User {
  id: number | string;
  name: string;
  screen_name: string;
  avatar_url: string;
  profile_banner_url: string;
  protected_flag: boolean;
  status_count: string;
  followee_count: string;
  statuses_updated_at: string;
  followees_updated_at: string;
}

export interface TweetUser {
  name: string;
  screen_name: string;
  avatar_url: string;
}
