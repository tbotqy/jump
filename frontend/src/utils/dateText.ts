import { DateParams } from "../api";

/*
 * Invalid patterns:
 * - null/null/null
 * - null/1/1
 * - 2019/null/1
 * - null/null/1
 */
function validateParams(year?: string, month?: string, day?: string): void {
  if(!year && !month && !day) {
    throw new Error("Nothing is given");
  }

  if(!year && month) {
    throw new Error("Year is not given while Month is given");
  }

  if(year && !month && day) {
    throw new Error("Month is not given while Year and Day is given");
  }

  if(!year && !month && day) {
    throw new Error("Year and Month are not given while Day is given");
  }
  return;
}

export default function dateText({ year, month, day }: DateParams): string {
  validateParams(year, month, day);

  let ret = `${year}年`;
  if(month) {
    ret += `${month}月`;
  }
  if(day) {
    ret += `${day}日`;
  }
  return ret;
}
