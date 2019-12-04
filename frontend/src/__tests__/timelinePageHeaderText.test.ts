import timelinePageHeaderText from "../utils/timelinePageHeaderText";

const screenName  = "screen_name";

describe("timelinePageHeaderText", () => {

  describe("With invalid params", () => {
    describe("undefined, 1, 1", () => {
      it("Throws an Error", () => {
        expect(() => timelinePageHeaderText(undefined as any, "1", "1", screenName)).toThrow("Year is not given while Month is given");
      });
    });
    describe("2019, undefined, 1", () => {
      it("Throws an Error", () => {
        expect(() => timelinePageHeaderText("2019", undefined as any, "1", screenName)).toThrow("Month is not given while Year and Day is given");
      });
    });
    describe("undefined, undefined, 1", () => {
      it("Throws an Error", () => {
        expect(() => timelinePageHeaderText(undefined as any, undefined as any, "1", screenName)).toThrow("Year and Month are not given while Day is given");
      });
    });
    describe("undefined, undefined, undefined", () => {
      it("Throws an Error", () => {
        expect(() => timelinePageHeaderText(undefined as any, undefined as any, undefined as any, screenName)).toThrow("Nothing is given");
      });
    });
  });

  describe("With valid params", () => {
    describe("with screen name", () => {
      describe("2019, 1, 1", () => {
        it("", () => {
          expect(timelinePageHeaderText("2019", "1", "1", screenName)).toEqual(`2019年1月1日の@${screenName}のツイート`);
        });
      });
    });
    describe("without screen name", () => {
      describe("2019, 1, 1", () => {
        it("", () => {
          expect(timelinePageHeaderText("2019", "1", "1", undefined)).toEqual("2019年1月1日のツイート");
        });
      });
    });
  });

});
