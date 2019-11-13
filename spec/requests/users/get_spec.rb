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
          expect(response.parsed_body.map { |item| item["screen_name"] }).to contain_exactly("a non-protected user", "a non-protected user")
        end
      end
      describe "number of returned items and their order" do
        before { (1..user_count).each { |n| create(:user, screen_name: "#{n}th_user") } }

        shared_examples "returns users ordered by from newest to oldest" do
          it do
            subject
            expected_screen_names_in_expected_order = (1..user_count).last(Settings.new_arrival_users_count).reverse.map { |n| "#{n}th_user" }
            expect(response.parsed_body.map { |item| item["screen_name"] }).to eq expected_screen_names_in_expected_order
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
            "screen_name": user.screen_name,
            "avatar_url":  user.avatar_url
          })
        end
      end
    end
  end
  describe "GET /me" do
    subject { get me_path, xhr: true }

    context "user has not been authenticated" do
      let(:user) { create(:user) }
      before { subject }
      it_behaves_like "respond with status code", :unauthorized
    end
    context "user has been authenticated" do
      describe "status code" do
        let(:user) { create(:user) }
        before do
          sign_in user
          subject
        end
        it_behaves_like "respond with status code", :ok
      end
      describe "response body" do
        describe "required attributes" do
          let(:name)           { "name" }
          let(:screen_name)    { "screen_name" }
          let(:avatar_url)     { "avatar_url" }
          let(:protected_flag) { true }
          let(:status_count)   { 100 }
          let(:followee_count) { 200 }
          let(:user) do
            create(:user,
              :with_statuses_and_followees,
              name:           name,
              screen_name:    screen_name,
              avatar_url:     avatar_url,
              protected_flag: protected_flag,
              status_count:   status_count,
              followee_count: followee_count
            )
          end

          before do
            sign_in user
            subject
          end

          it do
            expect(response.parsed_body.symbolize_keys).to include(
              id:             user.id,
              name:           name,
              screen_name:    screen_name,
              avatar_url:     avatar_url,
              protected_flag: protected_flag,
              status_count:   status_count.to_s(:delimited),
              followee_count: followee_count.to_s(:delimited)
            )
          end
        end
        describe "nullable attributes" do
          describe "#profile_banner_url" do
            before do
              sign_in user
              subject
            end
            context "null" do
              let(:user) { create(:user, profile_banner_url: nil) }
              it do
                expect(response.parsed_body.symbolize_keys).to include(profile_banner_url: nil)
              end
            end
            context "present" do
              let(:profile_banner_url) { "https://foo/bar" }
              let(:user) { create(:user, profile_banner_url: profile_banner_url) }
              it do
                expect(response.parsed_body.symbolize_keys).to include(profile_banner_url: profile_banner_url)
              end
            end
          end
          describe "#statuses_updated_at" do
            before do
              sign_in user
              subject
            end
            context "null" do
              let(:user) { create(:user, statuses_updated_at: nil) }
              it do
                expect(response.parsed_body.symbolize_keys).to include(statuses_updated_at: nil)
              end
            end
            context "present" do
              let(:at) { 1 }
              let(:user) { create(:user, statuses_updated_at: at) }
              it do
                expect(response.parsed_body.symbolize_keys).to include(statuses_updated_at: Time.zone.at(at).iso8601)
              end
            end
          end
          describe "#followees_updated_at" do
            context "null" do
              let(:user) { create(:user) } # user with no followee
              before do
                sign_in user
                subject
              end
              it do
                expect(response.parsed_body.symbolize_keys).to include(followees_updated_at: nil)
              end
            end
            context "present" do
              let(:user) { create(:user) }
              before do
                create_list(:followee, 2, user: user)
                create_list(:followee, 2) # the another user's followees
                sign_in user
                subject
              end
              it do
                expect(response.parsed_body.symbolize_keys).to include(followees_updated_at: user.followees.maximum(:created_at).iso8601)
              end
            end
          end
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
