require 'rails_helper'
describe "routings to admin" do
  it{ expect(get: "/admin/accounts").to route_to("admin#accounts") }
  it{ expect(get: "/admin/statuses").to route_to("admin#statuses") }
end