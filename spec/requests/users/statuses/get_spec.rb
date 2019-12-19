# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Users::Statuses", type: :request do
  describe "GET /users/:id/statuses" do
    subject { get user_statuses_path(user_id: user_id, year: year, month: month, day: day, page: page), xhr: true }

    context "not authenticated" do
      context "the target resource is protected" do
        let!(:user_id) { create(:user, protected_flag: true).id }
        let(:year)     { nil }
        let(:month)    { nil }
        let(:day)      { nil }
        let(:page)     { nil }
        before do
          create(:status, user_id: user_id, protected_flag: true)
          subject
        end
        it_behaves_like "unauthenticated request"
      end
      context "the target resource is not protected" do
        let!(:user_id) { create(:user, protected_flag: false).id }
        let(:year)     { nil }
        let(:month)    { nil }
        let(:day)      { nil }
        let(:page)     { nil }
        before do
          create(:status, user_id: user_id, protected_flag: false)
          subject
        end
        it_behaves_like "respond with status code", :ok
      end
    end
    context "authenticated" do
      context "user not found" do
        let!(:user) { create(:user) }
        let!(:user_id) { User.maximum(:id) + 1 }
        let(:year)     { nil }
        let(:month)    { nil }
        let(:day)      { nil }
        let(:page)     { nil }
        before do
          sign_in user
          subject
        end
        it_behaves_like "respond with status code", :not_found
      end
      context "user found" do
        context "the target user is not identical with the logged in user" do
          context "the target user's resources are protected" do
            let!(:signed_in_user) { create(:user) }
            let!(:another_user)   { create(:user, protected_flag: true) }
            let!(:user_id)        { another_user.id }
            let(:year)  { nil }
            let(:month) { nil }
            let(:day)   { nil }
            let(:page)  { nil }
            before do
              create(:status, user_id: user_id, protected_flag: true)
              sign_in signed_in_user
              subject
            end
            it_behaves_like "request for the other user's resource"
          end
          context "the target user's resources are not protected" do
            let!(:signed_in_user) { create(:user) }
            let!(:another_user)   { create(:user, protected_flag: false) }
            let!(:user_id)        { another_user.id }
            let(:year)  { nil }
            let(:month) { nil }
            let(:day)   { nil }
            let(:page)  { nil }
            before do
              create(:status, user_id: user_id, protected_flag: false)
              sign_in signed_in_user
              subject
            end
            it_behaves_like "respond with status code",  :ok
          end
        end
        context "the target user is identical with the logged in user" do
          context "user has no status" do
            let!(:user)    { create(:user) }
            let!(:user_id) { user.id }
            let(:year)     { nil }
            let(:month)    { nil }
            let(:day)      { nil }
            let(:page)     { nil }
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
                  status = create(:status, user: user, text: "to be ordered as 2nd item", tweeted_at: boundary_unixtime - 1)
                  status
                end
                let!(:status_tweeted_at_boundary) do
                  # specifying larger id than status_tweeted_before_boundary has, in order to test the sort of fetched collection.
                  id = status_tweeted_before_boundary.id + 1
                  status = create(:status, id: id, user: user, text: "to be ordered as 1st item",  tweeted_at: boundary_unixtime)
                  status
                end
                let!(:status_tweeted_after_boundary) do
                  status = create(:status, user: user, text: "to be filtered", tweeted_at: boundary_unixtime + 1)
                  status
                end
              end

              shared_examples "only includes those statuses that are tweeted at or before boundary time" do
                it do
                  expect(response.parsed_body.map { |item| item["text"] }).to contain_exactly(*[status_tweeted_before_boundary, status_tweeted_at_boundary].map(&:text))
                end
              end

              describe "yearly search" do
                describe "it only returns the statuses that have been tweeted (at or before) the end of specified year" do
                  let(:user) { create(:user) }

                  # pre-register user's statuses
                  let(:boundary_time) { Time.zone.local(year).end_of_year }
                  include_context "user has 3 statuses tweeted around the boundary_time"

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

              context "monthly search" do
                describe "it only returns the statuses that have been tweeted (at or before) the end of specified month" do
                  let(:user) { create(:user) }

                  # pre-register user's statuses
                  let(:boundary_time) { Time.zone.local(year, month).end_of_month }
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

                  include_examples "only includes those statuses that are tweeted at or before boundary time"
                end
              end

              describe "daily search" do
                describe "it only returns the statuses that have been tweeted (at or before) the end of specified day" do
                  let(:user) { create(:user) }

                  # pre-register user's statuses
                  let(:boundary_time) { Time.zone.local(year, month, day).end_of_day }
                  include_context "user has 3 statuses tweeted around the boundary_time"

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

              before do
                # Register the statuses tweeted in ending of the specified date.
                # To test if the sort is applied, registering in random order, by using #shuffle.
                (1..30).to_a.shuffle.map do |seconds_ago|
                  tweeted_at = Time.current.end_of_day - seconds_ago.seconds
                  create(:status, user: user, text: "#{seconds_ago}th-new status", tweeted_at: tweeted_at.to_i)
                end

                sign_in user
                subject
              end

              let(:user_id) { user.id }
              let(:year)    { nil }
              let(:month)   { nil }
              let(:day)     { nil }

              context "paging to non-blank page" do
                context "page 1" do
                  let(:page) { 1 }
                  describe "number of return values" do
                    it "returns as much as 25 (the maximum number for a page) statuses" do
                      expect(response.parsed_body.count).to eq 25
                    end
                  end
                  describe "sort under the pagination" do
                    it "includes first 25 statuses, ordered in new-tweet-first" do
                      expected_status_texts_with_expected_order = (1..25).map { |nth| "#{nth}th-new status" }
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
                      expected_status_texts_with_expected_order = (26..30).map { |nth| "#{nth}th-new status" }
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

            describe "should be scoped by user" do
              let(:targeted_user)     { create(:user) }
              let(:non_targeted_user) { create(:user) }
              let!(:targeted_user_statuses)     { create_list(:status, 2, user: targeted_user) }
              let!(:non_targeted_user_statuses) { create_list(:status, 2, user: non_targeted_user) }

              let(:user_id) { targeted_user.id }
              let(:year)    { nil }
              let(:month)   { nil }
              let(:day)     { nil }
              let(:page)    { nil }

              before { sign_in targeted_user }

              it do
                subject
                expect(response.parsed_body.map(&:deep_symbolize_keys)).to contain_exactly(*targeted_user_statuses.map(&:as_json))
              end
            end

            describe "keys and values" do
              let!(:user)   { create(:user) }
              let(:user_id) { user.id }
              let(:year)    { nil }
              let(:month)   { nil }
              let(:day)     { nil }
              let(:page)    { nil }
              before { sign_in user }
              describe "top level attribute" do
                context "status is not a retweet" do
                  let(:tweet_id)    { 12345 }
                  let(:text)        { "text" }
                  let!(:tweeted_at) { Time.current.to_i }
                  let(:is_retweet)  { false }
                  let!(:status) do
                    create(:status,
                      user:           user,
                      tweet_id:       tweet_id,
                      text:           text,
                      tweeted_at:     tweeted_at,
                      is_retweet:     is_retweet,
                      rt_avatar_url:  nil,
                      rt_name:        nil,
                      rt_screen_name: nil,
                      rt_text:        nil,
                      rt_source:      nil,
                      rt_created_at:  nil
                    )
                  end

                  it do
                    subject
                    expect(response.parsed_body.first.deep_symbolize_keys).to include(
                      tweetId:   tweet_id.to_s,
                      text:      text,
                      tweetedAt: Time.zone.at(tweeted_at).iso8601,
                      isRetweet: is_retweet,
                    )
                  end
                  it do
                    subject
                    expect(response.parsed_body.first.deep_symbolize_keys).not_to include(
                      rtName:       nil,
                      rtScreenName: nil,
                      rtText:       nil,
                      rtSource:     nil,
                      rtCreatedAt:  nil
                    )
                  end
                end
                context "status is a retweet" do
                  let(:tweet_id)       { 12345 }
                  let(:text)           { "text" }
                  let!(:tweeted_at)    { Time.current.to_i }
                  let(:is_retweet)     { true }
                  let(:rt_avatar_url)  { "rt_avatar_url" }
                  let(:rt_name)        { "rt_name" }
                  let(:rt_screen_name) { "rt_screen_name" }
                  let(:rt_text)        { "rt_text" }
                  let(:rt_source)      { "rt_source" }
                  let!(:rt_created_at) { (Time.current - 1.day).to_i }
                  let!(:status) do
                    create(:status,
                      user:           user,
                      tweet_id:       tweet_id,
                      text:           text,
                      tweeted_at:     tweeted_at,
                      is_retweet:     is_retweet,
                      rt_avatar_url:  rt_avatar_url,
                      rt_name:        rt_name,
                      rt_screen_name: rt_screen_name,
                      rt_text:        rt_text,
                      rt_source:      rt_source,
                      rt_created_at:  rt_created_at
                    )
                  end
                  it do
                    subject
                    expect(response.parsed_body.first.deep_symbolize_keys).to include(
                      tweetId:      tweet_id.to_s,
                      text:         text,
                      tweetedAt:    Time.zone.at(tweeted_at).iso8601,
                      isRetweet:    is_retweet,
                      rtName:       rt_name,
                      rtScreenName: rt_screen_name,
                      rtText:       rt_text,
                      rtSource:     rt_source,
                      rtCreatedAt:  Time.zone.at(rt_created_at).iso8601
                    )
                  end
                end
              end
              describe "associations" do
                describe "user" do
                  let!(:status) { create(:status, user: user) }
                  it do
                    subject
                    expect(response.parsed_body.first.deep_symbolize_keys).to include(user: user.as_tweet_user_json)
                  end
                end
                describe "urls" do
                  context "status has neither of urls and media" do
                    let!(:status) { create(:status, user: user) }
                    it do
                      subject
                      expect(response.parsed_body.first.deep_symbolize_keys).to include(urls: [])
                    end
                  end
                  context "status has some urls and media" do
                    let!(:status) { create(:status, user: user) }
                    let!(:urls)   { create_list(:url,    2, status: status) }
                    let!(:media)  { create_list(:medium, 2, status: status) }
                    it do
                      subject
                      expect(response.parsed_body.first.deep_symbolize_keys.fetch(:urls)).to contain_exactly(*(urls + media).as_json)
                    end
                  end
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

              before { sign_in user }

              context "user's statuses are public" do
                let!(:public_statuses) { create_list(:status, 2, protected_flag: false, user: user) }
                it do
                  subject
                  expect(response.parsed_body.map(&:deep_symbolize_keys)).to contain_exactly(*public_statuses.map(&:as_json))
                end
              end
              context "user's statuses are private" do
                let!(:protected_statuses) { create_list(:status, 2, protected_flag: true, user: user) }
                it do
                  subject
                  expect(response.parsed_body.map(&:deep_symbolize_keys)).to contain_exactly(*protected_statuses.map(&:as_json))
                end
              end
            end

            context "with no params specified" do
              let!(:user)   { create(:user) }
              let(:user_id) { user.id }
              let(:year)    { nil }
              let(:month)   { nil }
              let(:day)     { nil }
              let(:page)    { nil }

              before { sign_in user }

              let(:expected_per_page) { 25 }

              let!(:user_statuses) do
                # register statuses from newest to oldest
                now = Time.current
                (0..).first(expected_per_page + 1).map do |seconds_ago|
                  tweeted_at = now - seconds_ago.seconds
                  create(:status, user: user, tweeted_at: tweeted_at.to_i)
                end
              end

              it "returns at most 25 of the statuses" do
                subject
                expect(response.parsed_body.map(&:deep_symbolize_keys)).to contain_exactly(*user_statuses.first(expected_per_page).map(&:as_json))
              end
            end
          end
        end
      end
    end
  end
end
