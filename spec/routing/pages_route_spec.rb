require 'rails_helper'
describe "routings to static pages"do

  describe "get /" do
    it do
      expect(get: "/").to route_to(
        controller: "pages",
        action: "service_top"
      )
    end
  end

  describe "get /for_users" do
    it do
      expect(get: "/for_users").to route_to(
        controller: "pages",
        action: "for_users"
      )
    end
  end

  describe "get /browsers" do
    it do
      expect(get: "/browsers").to route_to(
        controller: "pages",
        action: "browsers"
      )
    end
  end

  describe "get /sorry" do
    it do
      expect(get: "/sorry").to route_to(
        controller: "pages",
        action: "sorry"
      )
    end
  end
end