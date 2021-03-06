# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Users", type: :request do
  describe "GET /" do
    subject { get users_path, xhr: true }
    context "no user exists" do
      before { subject }
      it_behaves_like "respond with status code", :not_found
    end
    context "some users exist" do
      describe "only non-protected users are included" do
        let!(:protected_users) { create_list(:user, 2, protected_flag: true, screen_name: "a protected user") }
        let!(:non_protected_users) { create_list(:user, 2, protected_flag: false, screen_name: "a non-protected user") }
        it do
          subject
          expect(response.parsed_body.map { |item| item["screenName"] }).to contain_exactly("a non-protected user", "a non-protected user")
        end
      end
      describe "number of returned items and their order" do
        before { (1..user_count).each { |n| create(:user, screen_name: "#{n}th_user") } }

        shared_examples "returns users ordered by from newest to oldest" do
          it do
            subject
            expected_screen_names_in_expected_order = (1..user_count).last(Settings.new_arrival_users_count).reverse.map { |n| "#{n}th_user" }
            expect(response.parsed_body.map { |item| item["screenName"] }).to eq expected_screen_names_in_expected_order
          end
        end
        shared_examples "returns n users" do |n|
          it "returns #{n} users" do
            subject
            expect(response.parsed_body.count).to eq n
          end
        end

        context "less than max" do
          let(:user_count) { Settings.new_arrival_users_count - 1 }
          include_examples "returns n users", Settings.new_arrival_users_count - 1
          it_behaves_like  "returns users ordered by from newest to oldest"
        end
        context "as much as max" do
          let(:user_count) { Settings.new_arrival_users_count }
          include_examples "returns n users", Settings.new_arrival_users_count
          it_behaves_like  "returns users ordered by from newest to oldest"
        end
        context "more than max" do
          let(:user_count) { Settings.new_arrival_users_count + 1 }
          include_examples "returns n users", Settings.new_arrival_users_count
          it_behaves_like  "returns users ordered by from newest to oldest"
        end
      end
      describe "response body" do
        let!(:user) { create(:user) }
        it do
          subject
          expect(response.parsed_body.first.symbolize_keys).to eq ({
            "name": user.name,
            "screenName": user.screen_name,
            "avatarUrl":  user.avatar_url
          })
        end
      end
    end
  end

  describe "GET /users/:screen_name" do
    subject { get user_page_path(screen_name: screen_name), xhr: true }
    describe "Authentication state doesn't matter" do
      let!(:screen_name) { create(:user).screen_name }
      before { subject }
      context "not authenticated" do
        it_behaves_like "respond with status code", :ok
      end
      context "authenticated" do
        it_behaves_like "respond with status code", :ok
      end
    end
    context "no user matches" do
      before do
        create(:user, screen_name: "existing_screen_name")
        subject
      end
      let(:screen_name) { "imaginary_screen_name" }
      it_behaves_like "respond with status code", :not_found
    end
    context "only single user matches" do
      let(:screen_name) { create(:user).screen_name }
      before { subject }
      it_behaves_like "respond with status code", :ok
      it { expect(response.body).to eq User.find_by!(screen_name: screen_name).to_json }
    end
    context "several users match" do
      let(:screen_name) { "duplicating_screen_name" }
      let!(:older_user) { create(:user, screen_name: screen_name, updated_at: Time.zone.at(1)) }
      let!(:newer_user) { create(:user, screen_name: screen_name, updated_at: Time.zone.at(2)) }
      before { subject }
      it_behaves_like "respond with status code", :ok
      it { expect(response.body).to eq newer_user.to_json }
    end
  end
end
