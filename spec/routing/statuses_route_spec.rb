require 'rails_helper'
describe "routings to ajax" do
  it{ expect(get: "/statuses/import").to             route_to("statuses#import") }
  it{ expect(get: "/your/tweets/2018-1-1").to        route_to("statuses#sent_tweets", date: "2018-1-1") }
  it{ expect(get: "/your/home_timeline/2018-1-1").to route_to("statuses#home_timeline", date: "2018-1-1") }
  it{ expect(get: "/public_timeline/2018-1-1").to    route_to("statuses#public_timeline", date: "2018-1-1") }
end