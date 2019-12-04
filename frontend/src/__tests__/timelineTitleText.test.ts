import timelineTitleText from "../utils/timelineTitleText";

const timelineName = "パブリックタイムライン";
const serviceName  = process.env.REACT_APP_SERVICE_NAME;

describe("timelineTitleText", () => {

  describe("With invalid params", () => {
    describe("timelineName is not given", () => {
      it("Throws an Error", () => {
        expect(() => timelineTitleText(undefined as any, { year: "1", month: "1", day: "1" })).toThrow("timelineName is not given.");
      });
    });
    describe("timelineName is given", () => {
      describe("undefined, 1, 1", () => {
        it("Throws an Error", () => {
          expect(() => timelineTitleText(timelineName, { year: undefined as any, month: "1", day: "1" })).toThrow("Year is not given while Month is given");
        });
      });
      describe("2019, undefined, 1", () => {
        it("Throws an Error", () => {
          expect(() => timelineTitleText(timelineName, { year: "2019", month: undefined as any, day: "1" })).toThrow("Month is not given while Year and Day is given");
        });
      });
      describe("undefined, undefined, 1", () => {
        it("Throws an Error", () => {
          expect(() => timelineTitleText(timelineName, { year: undefined as any, month: undefined as any, day: "1" })).toThrow("Year and Month are not given while Day is given");
        });
      });
    });
  });

  describe("With valid params", () => {
    describe("undefined, undefined, undefined", () => {
      it("", () => {
        expect(timelineTitleText(timelineName, { year: undefined, month: undefined, day: undefined })).toEqual(`${timelineName} - ${serviceName}`);
      });
    });
    describe("2019, undefined, undefined", () => {
      it("", () => {
        expect(timelineTitleText(timelineName, { year: "2019", month: undefined as any, day: undefined as any })).toEqual(`2019年の${timelineName} - ${serviceName}`);
      });
    });
    describe("2019, 1, undefined", () => {
      it("", () => {
        expect(timelineTitleText(timelineName, { year: "2019", month: "1", day: undefined as any })).toEqual(`2019年1月の${timelineName} - ${serviceName}`);
      });
    });
    describe("2019, 1, 1", () => {
      it("", () => {
        expect(timelineTitleText(timelineName, { year: "2019", month: "1", day: "1" })).toEqual(`2019年1月1日の${timelineName} - ${serviceName}`);
      });
    });
  });

});
