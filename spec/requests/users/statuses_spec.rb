# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Users::Statuses", type: :request do
  describe "GET /users/:id/statuses" do
    subject { get user_statuses_path(user_id: user_id, year: year, month: month, day: day, page: page) }

    shared_context "pre-register a user and its status whose user_id is not equal with params[:id]" do
      let!(:non_targeted_user)        { create(:user) }
      let!(:non_targeted_user_status) { create(:status, user: non_targeted_user, twitter_created_at: Time.local(year, month, day).to_i) }
    end

    context "not authenticated" do
      let!(:user) { create(:user) }
      let!(:user_id) { user.id }
      let(:year)  { 2019 }
      let(:month) { 3 }
      let(:day)   { 2 }
      let(:page)  { 1 }
      before { subject }
      it_behaves_like "unauthenticated request"
    end
    context "authenticated" do
      context "user not found" do
        let!(:user) { create(:user) }
        let!(:user_id) { user.id }
        let(:year)  { 2019 }
        let(:month) { 3 }
        let(:day)   { 2 }
        let(:page)  { 1 }
        before do
          sign_in user
          User.find(user_id).destroy!
          subject
        end
        it_behaves_like "respond with status code", :not_found
      end
      context "user found" do
        context "unauthorized to operate on the found user" do
          let!(:signed_in_user) { create(:user) }
          let!(:another_user)   { create(:user) }
          let!(:user_id)        { another_user.id }
          let(:year)  { 2019 }
          let(:month) { 3 }
          let(:day)   { 2 }
          let(:page)  { 1 }
          before do
            sign_in signed_in_user
            subject
          end
          it_behaves_like "request for the others' resource"
        end
        context "authorized to operate on the found user" do
          context "user has no status" do
            let!(:user)    { create(:user) }
            let!(:user_id) { user.id }
            let(:year)  { 2019 }
            let(:month) { 3 }
            let(:day)   { 2 }
            let(:page)  { 1 }
            before do
              sign_in user
              subject
            end
            it_behaves_like "respond with status code", :not_found
          end
          context "user has some statuses" do
            describe "boundary test on date-search" do
              shared_context "user has 3 statuses tweeted around the boundary_time" do
                let(:boundary_unixtime) { boundary_time.to_i }
                let!(:status_tweeted_before_boundary) do
                  status = create(:status, id: 1, user: user, text: "to be ordered as 2nd item", twitter_created_at: boundary_unixtime - 1)
                  create_list(:entity, 2, status: status)
                  status
                end
                let!(:status_tweeted_at_boundary) do
                  # specifying larger id than status_tweeted_before_boundary has, in order to test the sort of fetched collection.
                  status = create(:status, id: 2, user: user, text: "to be ordered as 1st item",  twitter_created_at: boundary_unixtime)
                  create_list(:entity, 2, status: status)
                  status
                end
                let!(:status_tweeted_after_boundary) do
                  status = create(:status, user: user, text: "to be filtered", twitter_created_at: boundary_unixtime + 1)
                  create_list(:entity, 2, status: status)
                  status
                end
              end

              # shared examples that are shared between yearly, monthly, and daily search descriptions
              shared_examples "examples" do
                describe "normal response code" do
                  it_behaves_like "respond with status code", :ok
                end
                describe "keys" do
                  it "has all the expected keys" do
                    expect(response.parsed_body.map(&:keys)).to all(
                      contain_exactly(
                        "tweet_id", "text", "tweeted_at", "is_retweet", "entities", "user"
                      )
                    )
                  end
                end
                describe "values" do
                  it "contains actual registered values in each item" do
                    expect(response.parsed_body.first.deep_symbolize_keys).to include(
                      tweet_id:   status_tweeted_at_boundary.status_id_str,
                      text:       status_tweeted_at_boundary.text,
                      tweeted_at: Time.at(status_tweeted_at_boundary.twitter_created_at).in_time_zone.iso8601,
                      is_retweet: status_tweeted_at_boundary.is_retweet,
                      entities:   status_tweeted_at_boundary.entities.as_json,
                      user:       status_tweeted_at_boundary.user.as_json
                    )
                    expect(response.parsed_body.last.deep_symbolize_keys).to include(
                      tweet_id:   status_tweeted_before_boundary.status_id_str,
                      text:       status_tweeted_before_boundary.text,
                      tweeted_at: Time.at(status_tweeted_before_boundary.twitter_created_at).in_time_zone.iso8601,
                      is_retweet: status_tweeted_before_boundary.is_retweet,
                      entities:   status_tweeted_before_boundary.entities.as_json,
                      user:       status_tweeted_before_boundary.user.as_json
                    )
                  end
                end
                describe "sort" do
                  it "lists the newest tweet as its first item" do
                    expect(response.parsed_body.first["text"]).to eq(status_tweeted_at_boundary.text)
                  end
                  it "lists the oldest tweet as its last item" do
                    expect(response.parsed_body.last["text"]).to  eq(status_tweeted_before_boundary.text)
                  end
                end
                describe "filtering" do
                  it "is filtered by given date" do
                    expect(response.parsed_body.map { |b| b["text"] }).to contain_exactly(status_tweeted_at_boundary.text, status_tweeted_before_boundary.text)
                  end
                end
                describe "pagination" do
                  context "something to show exists" do
                    let(:page) { 1 }
                    it_behaves_like "respond with status code", :ok
                    it { expect(response.body).not_to be_blank }
                  end
                  context "nothing to show" do
                    let(:page) { 2 }
                    it_behaves_like "respond with status code", :not_found
                  end
                end
              end

              describe "yearly search" do
                describe "it only returns the statuses that have been tweeted (at or before) the end of specified year" do
                  let(:user) { create(:user) }

                  # pre-register user's statuses
                  let(:boundary_time) { Time.local(year).end_of_year }
                  include_context "user has 3 statuses tweeted around the boundary_time"

                  include_context "pre-register a user and its status whose user_id is not equal with params[:id]"

                  let(:user_id) { user.id }
                  let(:year)    { 2019 }
                  let(:month)   { nil }
                  let(:day)     { nil }
                  let(:page)    { 1 }

                  before do
                    sign_in user
                    subject
                  end

                  include_examples "examples"
                end
              end

              context "monthly search" do
                describe "it only returns the statuses that have been tweeted (at or before) the end of specified month" do
                  let(:user) { create(:user) }

                  # pre-register user's statuses
                  let(:boundary_time) { Time.local(year, month).end_of_month }
                  include_context "user has 3 statuses tweeted around the boundary_time"

                  let(:user_id) { user.id }
                  let(:year)    { 2019 }
                  let(:month)   { 3 }
                  let(:day)     { nil }
                  let(:page)    { 1 }

                  before do
                    sign_in user
                    subject
                  end

                  include_examples "examples"
                end
              end

              describe "daily search" do
                describe "it only returns the statuses that have been tweeted (at or before) the end of specified day" do
                  let(:user) { create(:user) }

                  # pre-register user's statuses
                  let(:boundary_time) { Time.local(year, month, day).end_of_day }
                  include_context "user has 3 statuses tweeted around the boundary_time"

                  include_context "pre-register a user and its status whose user_id is not equal with params[:id]"

                  let(:user_id) { user.id }
                  let(:year)    { 2019 }
                  let(:month)   { 3 }
                  let(:day)     { 20 }
                  let(:page)    { 1 }

                  before do
                    sign_in user
                    subject
                  end

                  include_examples "examples"
                end
              end
            end
          end
        end
      end
    end
  end
end
