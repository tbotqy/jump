import dateText from "../utils/dateText";

describe("dateText", () => {

  describe("With invalid params", () => {
    describe("undefined, undefined, undefined", () => {
      it("", () => {
        expect(() => dateText({ year: undefined, month: undefined, day: undefined })).toThrow("Nothing is given");
      });
    });
    describe("undefined, 1, 1", () => {
      it("Throws an Error", () => {
        expect(() => dateText({ year: undefined, month: "1", day: "1" } as any)).toThrow("Year is not given while Month is given");
      });
    });
    describe("2019, undefined, 1", () => {
      it("Throws an Error", () => {
        expect(() => dateText({ year: "2019", month: undefined, day: "1" } as any)).toThrow("Month is not given while Year and Day is given");
      });
    });
    describe("undefined, undefined, 1", () => {
      it("Throws an Error", () => {
        expect(() => dateText({ year: undefined, month: undefined, day: "1" } as any)).toThrow("Year and Month are not given while Day is given");
      });
    });
  });

  describe("With valid params", () => {
    describe("2019, undefined, undefined", () => {
      it("", () => {
        expect(dateText({ year: "2019", month: undefined, day: undefined })).toEqual("2019年");
      });
    });
    describe("2019, 1, undefined", () => {
      it("", () => {
        expect(dateText({ year: "2019", month: "1", day: undefined })).toEqual("2019年1月");
      });
    });
    describe("2019, 1, 1", () => {
      it("", () => {
        expect(dateText({ year: "2019", month: "1", day: "1" })).toEqual("2019年1月1日");
      });
    });
  });

});
