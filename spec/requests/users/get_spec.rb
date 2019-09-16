# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Users", type: :request do
  describe "GET /users/:id" do
    subject { get user_path(id: id), xhr: true }

    context "user has not been authenticated" do
      let(:user) { create(:user) }
      let(:id)   { user.id }
      before { subject }
      it_behaves_like "respond with status code", :unauthorized
    end
    context "user has been authenticated" do
      context "user with given id doesn't exist" do
        let!(:user) { create(:user) }
        let(:id)    { User.maximum(:id) + 1 }
        before do
          sign_in user
          subject
        end
        it_behaves_like "respond with status code", :not_found
      end
      context "user with given id exists" do
        context "given id isn't an authenticated user's id" do
          let(:user) { create(:user) }
          let(:id)   { create(:user).id }
          before do
            sign_in user
            subject
          end
          it_behaves_like "request for the other user's resource"
        end
        context "given id is an authenticated user's id" do
          describe "status code" do
            let(:user) { create(:user) }
            let(:id)   { user.id }
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
              let(:status_count)   { 100 }
              let(:followee_count) { 200 }
              let(:user) do
                create(:user,
                  :with_statuses_and_followees,
                  name:           name,
                  screen_name:    screen_name,
                  avatar_url:     avatar_url,
                  status_count:   status_count,
                  followee_count: followee_count
                )
              end
              let(:id) { user.id }

              before do
                sign_in user
                subject
              end

              it do
                expect(response.parsed_body.symbolize_keys).to include(
                  name:           name,
                  screen_name:    screen_name,
                  avatar_url:     avatar_url,
                  status_count:   status_count.to_s(:delimited),
                  followee_count: followee_count.to_s(:delimited)
                )
              end
            end
            describe "nullable attributes" do
              describe "#statuses_updated_at" do
                before do
                  sign_in user
                  subject
                end
                context "null" do
                  let(:user) { create(:user, statuses_updated_at: nil) }
                  let(:id)   { user.id }
                  it do
                    expect(response.parsed_body.symbolize_keys).to include(statuses_updated_at: nil)
                  end
                end
                context "present" do
                  let(:at) { 1 }
                  let(:user) { create(:user, statuses_updated_at: at) }
                  let(:id)   { user.id }
                  it do
                    expect(response.parsed_body.symbolize_keys).to include(statuses_updated_at: Time.zone.at(at).iso8601)
                  end
                end
              end
              describe "#followees_updated_at" do
                context "null" do
                  let(:user) { create(:user) } # user with no followee
                  let(:id)   { user.id }
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
                  let(:id)   { user.id }
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
    end
  end
end
