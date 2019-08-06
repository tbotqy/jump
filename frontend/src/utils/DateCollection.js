class DateCollection {
  /*
    dates: [{"2019": [{"3": ["31", "29"]}]}]
  */
  constructor(dates) {
    this.dates = dates;
  }

  years() {
    return this.keysOf(this.dates);
  }

  latestYear() {
    return this.years()[0];
  }

  latestMonth() {
    return this.latestMonths()[0];
  }

  latestDay() {
    return this.latestDays()[0];
  }

  latestMonths() {
    return this.monthsByYear(this.latestYear());
  }

  latestDays() {
    const year  = this.latestYear();
    const month = this.latestMonth();
    return this.daysByYearAndMonth(year, month);
  }

  monthsByYear(year) {
    const monthsAndDays = this.monthsAndDaysByYear(year);
    return this.keysOf(monthsAndDays);
  }

  monthsAndDaysByYear(year) {
    const hash = this.dates.find( yearAndMonths => Object.keys(yearAndMonths)[0] === year );
    return hash[year];
  }

  daysByYearAndMonth(year, month) {
    const monthsAndDays = this.monthsAndDaysByYear(year);
    const monthAndDays  = monthsAndDays.find( monthAndDays => Object.keys(monthAndDays)[0] === month );
    return monthAndDays[month];
  }

  keysOf(collectionOfHash) {
    return collectionOfHash.flatMap( item => Object.keys(item) );
  }
}

export default DateCollection;
