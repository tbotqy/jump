export type TweetDays = string[]

export interface TweetMonth {
  [month: string]: TweetDays;
}

export interface TweetYear {
  [year: string]: TweetMonth[];
}

export type TweetDate = TweetYear

export type TweetDates = TweetDate[]
