import dateText from "../utils/dateText";

describe("dateText", () => {

  describe("With invalid params", () => {
    describe("null, null, null", () => {
      it("", () => {
        expect(() => dateText(null, null, null)).toThrow("Nothing is given");
      });
    });
    describe("null, 1, 1", () => {
      it("Throws an Error", () => {
        expect(() => dateText(null, 1, 1)).toThrow("Year is not given while Month is given");
      });
    });
    describe("2019, null, 1", () => {
      it("Throws an Error", () => {
        expect(() => dateText(2019, null, 1)).toThrow("Month is not given while Year and Day is given");
      });
    });
    describe("null, null, 1", () => {
      it("Throws an Error", () => {
        expect(() => dateText(null, null, 1)).toThrow("Year and Month are not given while Day is given");
      });
    });
  });

  describe("With valid params", () => {
    describe("2019, null, null", () => {
      it("", () => {
        expect(dateText(2019, null, null)).toEqual("2019年");
      });
    });
    describe("2019, 1, null", () => {
      it("", () => {
        expect(dateText(2019, 1, null)).toEqual("2019年1月");
      });
    });
    describe("2019, 1, 1", () => {
      it("", () => {
        expect(dateText(2019, 1, 1)).toEqual("2019年1月1日");
      });
    });
  });

});
