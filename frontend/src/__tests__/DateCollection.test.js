import DateCollection from "../utils/DateCollection";

const dates = [
  {
    "2019": [ { "12": [ "31", "30" ] }, { "11": [ "30", "29" ] } ]
  },
  {
    "2018": [ { "10": [ "28", "27" ] }, { "9": [ "26", "25" ] } ]
  }
];

const instance = new DateCollection(dates);

describe("#years", () => {
  it("returns all the years", () => {
    expect(instance.years()).toEqual([ "2019", "2018" ]);
  });
});

describe("#latestYear", () => {
  it("returns the latest year of the collection", () => {
    expect(instance.latestYear()).toEqual("2019");
  });
});

describe("#latestMonth", () => {
  it("returns the latest month of the collection", () => {
    expect(instance.latestMonth()).toEqual("12");
  });
});

describe("#latestDay", () => {
  it("returns the latest day of the collection", () => {
    expect(instance.latestDay()).toEqual("31");
  });
});

describe("#latestMonths", () => {
  it("returns the latest month of the collection", () => {
    expect(instance.latestMonth()).toEqual("12");
  });
});

describe("#latestDays", () => {
  it("returns the days of the latest month of the collection", () => {
    expect(instance.latestDays()).toEqual([ "31", "30" ]);
  });
});

describe("#latestMonthByYear", () => {
  it("returns the latest month of given year from collection", () => {
    expect(instance.latestMonthByYear("2018")).toEqual("10");
  });
});

describe("#latestDayByYearAndMonth", () => {
  it("returns the latest month of given year from collection", () => {
    expect(instance.latestDayByYearAndMonth("2018", "9")).toEqual("26");
  });
});

describe("#monthsByYear", () => {
  it("returns the months of given year", () => {
    expect(instance.monthsByYear("2018")).toEqual([ "10", "9" ]);
  });
});

describe("#monthsAndDaysByYear", () => {
  it("returns the hash of given year", () => {
    expect(instance.monthsAndDaysByYear("2018")).toEqual([ { "10": [ "28", "27" ] }, { "9": [ "26", "25" ] } ]);
  });
});

describe("#daysByYearAndMonth", () => {
  it("returns the hash of given year and month", () => {
    expect(instance.daysByYearAndMonth("2018", "9")).toEqual([ "26", "25" ]);
  });
});

describe("#keysOf", () => {
  it("returns the keys of given hash", () => {
    expect(
      instance.keysOf(
        [
          { "a": "A" },
          { "b": "B" }
        ]
      )
    ).toEqual([ "a", "b" ]);
  });
});
