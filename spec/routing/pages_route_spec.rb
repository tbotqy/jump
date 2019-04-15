# frozen_string_literal: true

require "rails_helper"
describe "routings to static pages" do
  it { expect(get: "/").to route_to("pages#service_top") }
  it { expect(get: "/for_users").to route_to("pages#for_users") }
end
