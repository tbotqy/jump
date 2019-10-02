import timelinePageHeaderText from "../utils/timelinePageHeaderText";

const screenName  = "screen_name";

describe("timelinePageHeaderText", () => {

  describe("With invalid params", () => {
    describe("null, 1, 1", () => {
      it("Throws an Error", () => {
        expect(() => timelinePageHeaderText( null, 1, 1, screenName)).toThrow("Year is not given while Month is given");
      });
    });
    describe("2019, null, 1", () => {
      it("Throws an Error", () => {
        expect(() => timelinePageHeaderText(2019, null, 1, screenName)).toThrow("Month is not given while Year and Day is given");
      });
    });
    describe("null, null, 1", () => {
      it("Throws an Error", () => {
        expect(() => timelinePageHeaderText(null, null, 1, screenName)).toThrow("Year and Month are not given while Day is given");
      });
    });
    describe("null, null, null", () => {
      it("Throws an Error", () => {
        expect(() => timelinePageHeaderText(null, null, null, screenName)).toThrow("Nothing is given");
      });
    });
  });

  describe("With valid params", () => {
    describe("with screen name", () => {
      describe("2019, 1, 1", () => {
        it("", () => {
          expect(timelinePageHeaderText(2019, 1, 1, screenName)).toEqual(`2019年1月1日の@${screenName}のツイート`);
        });
      });
    });
    describe("without screen name", () => {
      describe("2019, 1, 1", () => {
        it("", () => {
          expect(timelinePageHeaderText(2019, 1, 1, null)).toEqual("2019年1月1日のツイート");
        });
      });
    });
  });

});
