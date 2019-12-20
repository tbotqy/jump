interface None {
  year: undefined;
  month: undefined;
  day: undefined;
}

interface YearOnly {
  year: string;
  month: undefined;
  day: undefined;
}

interface YearAndMonthOnly {
  year: string;
  month: string;
  day: undefined;
}

interface All {
  year: string;
  month: string;
  day: string;
}

export type DateParams = None | YearOnly | YearAndMonthOnly | All
export type PaginatableDateParams = DateParams & { page?: number }
