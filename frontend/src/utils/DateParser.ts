type Days = string[]

interface Month {
  [month: string]: Days;
}

interface Year {
  [year: string]: Month[];
}

export type Dates = Year[]

class DateParser {
  /*
    dates: [{"2019": [{"3": ["31", "29"]}]}]
  */
  constructor(private dates: Dates) {
    if(dates.length === 0) {
      throw Error("Given dates is empty.");
    }
  }

  public years(): string[] {
    return this.keysOf(this.dates);
  }

  public latestYear(): string {
    return this.years()[0];
  }

  public latestMonthByYear(year: string): string {
    const months: string[] = this.monthsByYear(year);
    return months[0];
  }

  public latestDayByYearAndMonth(year: string, month: string): string {
    const days: Days = this.daysByYearAndMonth(year, month);
    return days[0];
  }

  public monthsByYear(year: string): string[] {
    const monthsAndDays: Month[] = this.monthsAndDaysByYear(year);
    return this.keysOf(monthsAndDays);
  }

  public daysByYearAndMonth(year: string, month: string): string[] {
    const monthsAndDays: Month[] = this.monthsAndDaysByYear(year);
    const monthAndDays: Month | undefined  = monthsAndDays.find( monthAndDays => Object.keys(monthAndDays)[0] === month );
    if(!monthAndDays) {
      return [];
    }else{
      return monthAndDays[month];
    }
  }

  private latestMonth(): string {
    return this.latestMonths()[0];
  }

  private latestDay(): string {
    return this.latestDays()[0];
  }

  private latestMonths(): string[] {
    return this.monthsByYear(this.latestYear());
  }

  private latestDays(): Days {
    const year: string  = this.latestYear();
    const month: string = this.latestMonth();
    return this.daysByYearAndMonth(year, month);
  }

  private monthsAndDaysByYear(year: string): Month[] {
    const hash: Year | undefined = this.dates.find( (yearAndMonths: Year) => Object.keys(yearAndMonths)[0] === year );
    if(!hash) {
      return [];
    }else{
      return hash[year];
    }
  }

  private keysOf(collectionOfHash: {}[]): string[] {
    return collectionOfHash.flatMap( (item: Year | Month): string[] => Object.keys(item) );
  }
}

export default DateParser;
