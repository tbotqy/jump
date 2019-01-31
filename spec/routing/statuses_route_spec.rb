require 'rails_helper'
describe "routings to ajax" do
  it{ expect(get: "/statuses/import").to             route_to("statuses#import") }

  describe 'routings to user_time' do
    it{ expect(get: "/user_timeline/2018").to     route_to("statuses#user_timeline", year: "2018") }
    it{ expect(get: "/user_timeline/2018/2").to   route_to("statuses#user_timeline", year: "2018", month: "2") }
    it{ expect(get: "/user_timeline/2018/2/1").to route_to("statuses#user_timeline", year: "2018", month: "2", day: "1") }
  end

  describe 'routings to home_time' do
    it{ expect(get: "/home_timeline/2018").to     route_to("statuses#home_timeline", year: "2018") }
    it{ expect(get: "/home_timeline/2018/2").to   route_to("statuses#home_timeline", year: "2018", month: "2") }
    it{ expect(get: "/home_timeline/2018/2/1").to route_to("statuses#home_timeline", year: "2018", month: "2", day: "1") }
  end

  describe 'routings to public_timeline' do
    it{ expect(get: "/public_timeline/2018").to     route_to("statuses#public_timeline", year: "2018") }
    it{ expect(get: "/public_timeline/2018/2").to   route_to("statuses#public_timeline", year: "2018", month: "2") }
    it{ expect(get: "/public_timeline/2018/2/1").to route_to("statuses#public_timeline", year: "2018", month: "2", day: "1") }
  end
end
