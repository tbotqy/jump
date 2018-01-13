require 'rails_helper'
describe "routings to session" do

  describe "get /auth/twitter/callback" do
    it do
      expect(get: "/auth/twitter/callback").to route_to(
        controller: "session",
        action: "login"
      )
    end
  end

  describe "get /auth/failure" do
    it do
      expect(get: "/auth/failure").to route_to(
        controller: "session",
        action: "logout"
      )
    end
  end

  describe "get /logout" do
    it do
      expect(get: "/logout").to route_to(
        controller: "session",
        action: "logout"
      )
    end
  end
end