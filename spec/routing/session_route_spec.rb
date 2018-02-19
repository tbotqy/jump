require 'rails_helper'
describe "routings to session" do
  it{ expect(get: "/auth/twitter/callback").to route_to("session#login") }
  it{ expect(get: "/auth/failure").to route_to("session#logout") }
  it{ expect(get: "/logout").to route_to("session#logout") }
end