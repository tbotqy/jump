import timelineTitleText from "../utils/timelineTitleText";

const timelineName = "パブリックタイムライン";
const serviceName  = process.env.REACT_APP_SERVICE_NAME;

describe("timelineTitleText", () => {

  describe("With invalid params", () => {
    describe("timelineName is not given", () => {
      it("Throws an Error", () => {
        expect(() => timelineTitleText(null, 1, 1, 1)).toThrow("timelineName is not given.");
      });
    });
    describe("timelineName is given", () => {
      describe("null, 1, 1", () => {
        it("Throws an Error", () => {
          expect(() => timelineTitleText(timelineName, null, 1, 1)).toThrow("Year is not given while Month is given");
        });
      });
      describe("2019, null, 1", () => {
        it("Throws an Error", () => {
          expect(() => timelineTitleText(timelineName, 2019, null, 1)).toThrow("Month is not given while Year and Day is given");
        });
      });
      describe("null, null, 1", () => {
        it("Throws an Error", () => {
          expect(() => timelineTitleText(timelineName, null, null, 1)).toThrow("Year and Month are not given while Day is given");
        });
      });
    });
  });

  describe("With valid params", () => {
    describe("null, null, null", () => {
      it("", () => {
        expect(timelineTitleText(timelineName, null, null, null)).toEqual(`${timelineName} - ${serviceName}`);
      });
    });
    describe("2019, null, null", () => {
      it("", () => {
        expect(timelineTitleText(timelineName, 2019, null, null)).toEqual(`2019年の${timelineName} - ${serviceName}`);
      });
    });
    describe("2019, 1, null", () => {
      it("", () => {
        expect(timelineTitleText(timelineName, 2019, 1, null)).toEqual(`2019年1月の${timelineName} - ${serviceName}`);
      });
    });
    describe("2019, 1, 1", () => {
      it("", () => {
        expect(timelineTitleText(timelineName, 2019, 1, 1)).toEqual(`2019年1月1日の${timelineName} - ${serviceName}`);
      });
    });
  });

});
