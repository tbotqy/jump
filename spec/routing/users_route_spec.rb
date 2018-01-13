require 'rails_helper'
describe "routings to users" do
  it{ expect(get: "/your/data").to route_to("users#setting")}
end