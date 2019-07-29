# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Users::FolloweeStatuses", type: :request do
  describe "GET /users/:id/followee_statuses" do
    subject { get user_followee_statuses_path(user_id: user_id, year: year, month: month, day: day, page: page) }

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
          it_behaves_like "request for the other user's resource"
        end
        context "authorized to operate on the found user" do
          context "user has no followee" do
            let(:user)    { create(:user) }
            let(:user_id) { user.id }
            let(:year)    { 2019 }
            let(:month)   { 10 }
            let(:day)     { 1 }
            let(:page)    { 1 }
            before do
              sign_in user
              subject
            end
            it_behaves_like "respond with status code", :not_found
          end
          context "user has followee" do
            context "followee has no status" do
              let!(:user) { create(:user) }
              let!(:followee) do
                followee = create(:user)
                create(:followee, user: user, twitter_id: followee.twitter_id)
                followee
              end
              let(:user_id) { user.id } # set the id of the user who has no status
              let(:year)    { 2019 }
              let(:month)   { 10 }
              let(:day)     { 1 }
              let(:page)    { 1 }
              before do
                sign_in user
                subject
              end
              it_behaves_like "respond with status code", :not_found
            end
            context "followee has some statuses" do
              shared_context "user's followee has 3 statuses tweeted around the boundary_time" do |without_entities|
                let(:boundary_unixtime) { boundary_time.to_i }
                let!(:status_tweeted_before_boundary) do
                  status = create(:status, user: followee, text: "to be ordered as 2nd item", tweeted_at: boundary_unixtime - 1)
                  create_list(:entity, 2, status: status) unless without_entities
                  status
                end
                let!(:status_tweeted_at_boundary) do
                  # specifying larger id than status_tweeted_before_boundary has, in order to test the sort of fetched collection.
                  id = status_tweeted_before_boundary.id + 1
                  status = create(:status, id: id, user: followee, text: "to be ordered as 1st item", tweeted_at: boundary_unixtime)
                  create_list(:entity, 2, status: status) unless without_entities
                  status
                end
                let!(:status_tweeted_after_boundary) do
                  status = create(:status, user: followee, text: "to be filtered", tweeted_at: boundary_unixtime + 1)
                  create_list(:entity, 2, status: status) unless without_entities
                  status
                end
              end

              shared_examples "only includes those statuses that are tweeted at or before boundary time" do
                it do
                  expect(response.parsed_body.map { |item| item["text"] }).to contain_exactly(*[status_tweeted_before_boundary, status_tweeted_at_boundary].map(&:text))
                end
              end

              describe "boundary test on date-search" do
                describe "yearly search" do
                  describe "it only returns the statuses that have been tweeted at or before the end of specified year" do
                    let!(:user) { create(:user) }
                    let!(:followee) do
                      followee = create(:followee, user: user)
                      create(:user, twitter_id: followee.twitter_id)
                    end
                    # pre-register user's followee's statuses
                    let(:boundary_time) { Time.local(year).end_of_year }
                    include_context "user's followee has 3 statuses tweeted around the boundary_time"

                    let(:user_id) { user.id }
                    let(:year)    { 2019 }
                    let(:month)   { nil }
                    let(:day)     { nil }
                    let(:page)    { 1 }

                    before do
                      sign_in user
                      subject
                    end
                    include_examples "only includes those statuses that are tweeted at or before boundary time"
                  end
                end

                describe "monthly search" do
                  describe "it only returns the statuses that have been tweeted (at or before) the end of specified month" do
                    let(:user) { create(:user) }
                    let!(:followee) do
                      followee = create(:followee, user: user)
                      create(:user, twitter_id: followee.twitter_id)
                    end
                    # pre-register user's followee's statuses
                    let(:boundary_time) { Time.local(year, month).end_of_month }
                    include_context "user's followee has 3 statuses tweeted around the boundary_time"

                    let(:user_id) { user.id }
                    let(:year)    { 2019 }
                    let(:month)   { 3 }
                    let(:day)     { nil }
                    let(:page)    { 1 }

                    before do
                      sign_in user
                      subject
                    end
                    include_examples "only includes those statuses that are tweeted at or before boundary time"
                  end
                end

                describe "daily search" do
                  describe "it only returns the statuses that have been tweeted (at or before) the end of specified day" do
                    let(:user) { create(:user) }
                    let!(:followee) do
                      followee = create(:followee, user: user)
                      create(:user, twitter_id: followee.twitter_id)
                    end
                    # pre-register user's followee's statuses
                    let(:boundary_time) { Time.local(year, month, day).end_of_day }
                    include_context "user's followee has 3 statuses tweeted around the boundary_time"

                    let(:user_id) { user.id }
                    let(:year)    { 2019 }
                    let(:month)   { 3 }
                    let(:day)     { 20 }
                    let(:page)    { 1 }

                    before do
                      sign_in user
                      subject
                    end
                    include_examples "only includes those statuses that are tweeted at or before boundary time"
                  end
                end
              end

              describe "pagination and order" do
                let!(:user) { create(:user) }
                let!(:followee) do
                  followee = create(:followee, user: user)
                  create(:user, twitter_id: followee.twitter_id)
                end
                before do
                  # Register the statuses tweeted in ending of the specified date.
                  # To test if the sort is applied, registering in random order, by using #shuffle.
                  (1..15).to_a.shuffle.each do |seconds_ago|
                    tweeted_at = Time.local(year, month, day).end_of_day - seconds_ago.seconds
                    create(:status, user: followee, text: "#{seconds_ago}th-new status", tweeted_at: tweeted_at.to_i)
                  end

                  sign_in user
                  subject
                end

                let(:user_id) { user.id }
                let(:year)    { 2019 }
                let(:month)   { 3 }
                let(:day)     { 20 }
                context "status to show exists" do
                  context "page 1" do
                    let(:page) { 1 }
                    describe "number of return values" do
                      it "returns as much as 10 (the maximum number for a page) statuses" do
                        expect(response.parsed_body.count).to eq 10
                      end
                    end
                    describe "sort under the pagination" do
                      it "includes first 10 statuses, ordered in new-tweet-first" do
                        expected_status_texts_with_expected_order = (1..10).map { |nth| "#{nth}th-new status" }
                        expect(response.parsed_body.map { |item| item["text"] }).to eq expected_status_texts_with_expected_order
                      end
                    end
                  end
                  context "page 2" do
                    let(:page) { 2 }
                    describe "number of return values" do
                      it "returns as much as 5 (the number of statuses in 2nd page) statuses" do
                        expect(response.parsed_body.count).to eq 5
                      end
                    end
                    describe "sort under the pagination" do
                      it "includes last 5 statuses, ordered in new-tweet-first" do
                        expected_status_texts_with_expected_order = (11..15).map { |nth| "#{nth}th-new status" }
                        expect(response.parsed_body.map { |item| item["text"] }).to eq expected_status_texts_with_expected_order
                      end
                    end
                  end
                end
                context "paging to a blank page" do
                  context "page 3" do
                    let(:page) { 3 }
                    it_behaves_like "respond with status code", :not_found
                  end
                end
              end

              describe "filtering by followee's user_id" do
                # register a user whose id is to be passed as parameter
                let!(:user) { create(:user) }
                let!(:user_followee) do
                  followee = create(:user)
                  create(:followee, user: user, twitter_id: followee.twitter_id)
                  followee
                end
                let!(:user_folowee_statuses) { create_list(:status, 3, text: "user's followee's status", user: user_followee) }

                # register a user whose id is other than the one to be passed as parameter
                let!(:another_user) { create(:user) }
                let!(:another_user_followee) do
                  followee = create(:user)
                  create(:followee, user: another_user, twitter_id: followee.twitter_id)
                  followee
                end
                let!(:another_user_followee_statuses) { create_list(:status, 3, text: "another user's followee's status", user: another_user_followee) }

                let(:user_id) { user.id }
                let(:year)    { nil }
                let(:month)   { nil }
                let(:day)     { nil }
                let(:page)    { 1 }

                before do
                  sign_in user
                  subject
                end
                it "only returns user's followee's statuses" do
                  expect(response.parsed_body.map { |item| item["text"] }).to contain_exactly(*user_folowee_statuses.pluck(:text))
                end
              end

              describe "content of returned body" do
                let(:user) { create(:user) }
                let!(:followee) do
                  followee = create(:followee, user: user)
                  create(:user, twitter_id: followee.twitter_id)
                end
                # pre-register user's followee's statuses
                let(:boundary_time) { Time.local(year, month, day).end_of_day }

                let(:user_id) { user.id }
                let(:year)    { 2019 }
                let(:month)   { 3 }
                let(:day)     { 20 }
                let(:page)    { 1 }

                include_context "user's followee has 3 statuses tweeted around the boundary_time"

                before do
                  sign_in user
                  subject
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
                describe "value of attr 'entities'" do
                  include_context "user's followee has 3 statuses tweeted around the boundary_time"
                  context "followee' status has entity" do
                    it { expect(response.parsed_body.first.deep_symbolize_keys[:entities]).to eq status_tweeted_at_boundary.entities.as_json }
                  end
                  context "followee' status has no entity" do
                    # override already-declared context
                    include_context "user's followee has 3 statuses tweeted around the boundary_time", true
                    it { expect(response.parsed_body.first.deep_symbolize_keys[:entities]).to eq [] }
                  end
                end
                describe "values" do
                  it "contains actual registered values in each item" do
                    expect(response.parsed_body.first.deep_symbolize_keys).to include(
                      tweet_id:   status_tweeted_at_boundary.tweet_id,
                      text:       status_tweeted_at_boundary.text,
                      tweeted_at: Time.at(status_tweeted_at_boundary.tweeted_at).in_time_zone.iso8601,
                      is_retweet: status_tweeted_at_boundary.is_retweet,
                      entities:   status_tweeted_at_boundary.entities.as_json,
                      user:       status_tweeted_at_boundary.user.as_json
                    )
                    expect(response.parsed_body.last.deep_symbolize_keys).to include(
                      tweet_id:   status_tweeted_before_boundary.tweet_id,
                      text:       status_tweeted_before_boundary.text,
                      tweeted_at: Time.at(status_tweeted_before_boundary.tweeted_at).in_time_zone.iso8601,
                      is_retweet: status_tweeted_before_boundary.is_retweet,
                      entities:   status_tweeted_before_boundary.entities.as_json,
                      user:       status_tweeted_before_boundary.user.as_json
                    )
                  end
                end
              end

              describe "both public and private statuses are collected" do
                let!(:user)   { create(:user) }
                let(:user_id) { user.id }
                let(:year)    { nil }
                let(:month)   { nil }
                let(:day)     { nil }
                let(:page)    { nil }

                let!(:followee) do
                  followee = create(:user)
                  create(:followee, user: user, twitter_id: followee.twitter_id)
                  followee
                end

                before { sign_in user }

                context "user's followee's statuses are public" do
                  let!(:public_followee_statuses) { create_list(:status, 2, private_flag: false, user: followee) }
                  it do
                    subject
                    expect(response.parsed_body.map(&:deep_symbolize_keys)).to contain_exactly(*public_followee_statuses.map(&:as_json))
                  end
                end
                context "user's followee's statuses are private" do
                  let!(:private_followee_statuses) { create_list(:status, 2, private_flag: true, user: followee) }
                  it do
                    subject
                    expect(response.parsed_body.map(&:deep_symbolize_keys)).to contain_exactly(*private_followee_statuses.map(&:as_json))
                  end
                end
              end

              describe "with no params specified" do
                let!(:user)   { create(:user) }
                let(:user_id) { user.id }
                let(:year)  { nil }
                let(:month) { nil }
                let(:day)   { nil }
                let(:page)  { nil }

                let(:expected_per_page) { 10 }

                let!(:followee) do
                  followee = create(:user)
                  create(:followee, user: user, twitter_id: followee.twitter_id)
                  followee
                end

                let!(:followee_statuses) do
                  # register statuses from newest to oldest
                  (0..).first(expected_per_page + 1).map do |seconds_ago|
                    tweeted_at = Time.now.utc - seconds_ago.seconds
                    create(:status, user: followee, tweeted_at: tweeted_at.to_i)
                  end
                end

                before do
                  sign_in user
                  travel_to(Time.now.utc)
                end
                after  { travel_back }

                it "returns at most 10 of the statuses tweeted before or eq to Time.now" do
                  subject
                  expect(response.parsed_body.map(&:deep_symbolize_keys)).to contain_exactly(*followee_statuses.first(expected_per_page).map(&:as_json))
                end
              end
            end
          end
        end
      end
    end
  end
end
