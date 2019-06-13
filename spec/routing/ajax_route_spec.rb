# frozen_string_literal: true

require "rails_helper"
describe "routings to ajax" do
  it { expect(post: "/ajax/check_profile_update").to route_to("ajax#check_profile_update") }
  it { expect(post: "/ajax/check_friend_update").to  route_to("ajax#check_friend_update") }
  it { expect(post: "/ajax/deactivate_account").to route_to("ajax#deactivate_account") }
  it { expect(post: "/ajax/delete_status").to route_to("ajax#delete_status") }
  it { expect(post: "/ajax/read_more").to route_to("ajax#read_more") }
  it { expect(get:  "/ajax/term_selector").to route_to("ajax#term_selector") }
  it { expect(post: "/ajax/make_initial_import").to  route_to("ajax#make_initial_import") }
  it { expect(post: "/ajax/start_tweet_import").to   route_to("ajax#start_tweet_import") }
  it { expect(post: "/ajax/check_import_progress").to route_to("ajax#check_import_progress") }
  it { expect(get:  "/ajax/switch_term").to route_to("ajax#switch_term") }
end