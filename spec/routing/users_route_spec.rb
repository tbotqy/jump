# frozen_string_literal: true

require "rails_helper"
describe "routings to users" do
  it { expect(get: "/users/setting").to route_to("users#setting") }
  it { expect(get: "/users/delete_account").to route_to("users#delete_account") }
end
