# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Statuses", type: :request do
  describe "GET /statuses" do
    subject { get statuses_path(year: year, month: month, day: day, page: page) }

    describe "no authentication needed" do
      context "not authenticated" do
        let(:year)  { 2019 }
        let(:month) { 7 }
        let(:day)   { 4 }
        let(:page)  { 1 }
        before do
          3.times { |i| create(:status, private_flag: false, tweet_id: i, tweeted_at: Time.local(year, month, day).end_of_day.to_i) }
          subject
        end
        it_behaves_like "respond with status code", :ok
      end
    end

    context "no status exists" do
      let(:year)  { 2019 }
      let(:month) { 7 }
      let(:day)   { 4 }
      let(:page)  { 1 }
      before { subject }
      it_behaves_like "respond with status code", :not_found
    end
    context "some statuses exist" do
      describe "boundary test on date-search" do
        shared_context "there are 3 public statuses tweeted around the boundary_time" do
          let(:boundary_unixtime) { boundary_time.to_i }
          let!(:status_tweeted_before_boundary) do
            status = create(:status, text: "to be ordered as 2nd item", private_flag: false, tweeted_at: boundary_unixtime - 1)
            create_list(:entity, 2, status: status)
            status
          end
          let!(:status_tweeted_at_boundary) do
            # specifying larger id than status_tweeted_before_boundary has, in order to test the sort of fetched collection.
            id = status_tweeted_before_boundary.id + 1
            status = create(:status, id: id, text: "to be ordered as 1st item", private_flag: false, tweeted_at: boundary_unixtime)
            create_list(:entity, 2, status: status)
            status
          end
          let!(:status_tweeted_after_boundary) do
            status = create(:status, text: "to be filtered", private_flag: false, tweeted_at: boundary_unixtime + 1)
            create_list(:entity, 2, status: status)
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
            # pre-register user's statuses
            let(:boundary_time) { Time.local(year).end_of_year }
            include_context "there are 3 public statuses tweeted around the boundary_time"

            let(:year)  { 2019 }
            let(:month) { nil }
            let(:day)   { nil }
            let(:page)  { 1 }

            before { subject }

            include_examples "only includes those statuses that are tweeted at or before boundary time"
          end
        end

        context "monthly search" do
          describe "it only returns the statuses that have been tweeted (at or before) the end of specified month" do
            # pre-register user's statuses
            let(:boundary_time) { Time.local(year, month).end_of_month }
            include_context "there are 3 public statuses tweeted around the boundary_time"

            let(:year)  { 2019 }
            let(:month) { 3 }
            let(:day)   { nil }
            let(:page)  { 1 }

            before { subject }

            include_examples "only includes those statuses that are tweeted at or before boundary time"
          end
        end

        describe "daily search" do
          describe "it only returns the statuses that have been tweeted (at or before) the end of specified day" do
            # pre-register user's statuses
            let(:boundary_time) { Time.local(year, month, day).end_of_day }
            include_context "there are 3 public statuses tweeted around the boundary_time"

            let(:year)  { 2019 }
            let(:month) { 3 }
            let(:day)   { 20 }
            let(:page)  { 1 }

            before { subject }

            include_examples "only includes those statuses that are tweeted at or before boundary time"
          end
        end
      end

      describe "pagination and order" do
        before do
          # Register the statuses tweeted in ending of the specified date.
          # To test if the sort is applied, registering in random order, by using #shuffle.
          (1..15).to_a.shuffle.map do |seconds_ago|
            tweeted_at = Time.now.utc.end_of_day - seconds_ago.seconds
            create(:status, text: "#{seconds_ago}th-new status", tweeted_at: tweeted_at.to_i)
          end
          subject
        end

        let(:year)  { nil }
        let(:month) { nil }
        let(:day)   { nil }

        context "paging to non-blank page" do
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

      describe "should not be scoped by user" do
        let(:alice) { create(:user) }
        let(:bob)   { create(:user) }
        let!(:alice_status) { create(:status, user: alice) }
        let!(:bob_status)   { create(:status, user: bob) }

        let(:year)  { nil }
        let(:month) { nil }
        let(:day)   { nil }
        let(:page)  { nil }

        it do
          subject
          expect(response.parsed_body.map(&:deep_symbolize_keys)).to contain_exactly(*[alice_status, bob_status].map(&:as_json))
        end
      end

      describe "keys and values" do
        let(:year)  { nil }
        let(:month) { nil }
        let(:day)   { nil }
        let(:page)  { nil }

        let!(:status) { create(:status) }

        before { subject }

        describe "keys" do
          it do
            expect(response.parsed_body.first.keys).to contain_exactly(
              "tweet_id", "text", "tweeted_at", "is_retweet", "entities", "user"
            )
          end
        end
        describe "value of attr 'entities'" do
          xit "TODO: implement"
        end
        describe "values" do
          it do
            expect(response.parsed_body.first.deep_symbolize_keys).to include(
              tweet_id:   status.tweet_id,
              text:       status.text,
              tweeted_at: Time.at(status.tweeted_at).in_time_zone.iso8601,
              is_retweet: status.is_retweet,
              entities:   status.entities.as_json,
              user:       status.user.as_json
            )
          end
        end
      end

      describe "only public statuses are collected" do
        let(:year)    { nil }
        let(:month)   { nil }
        let(:day)     { nil }
        let(:page)    { nil }

        let!(:public_statuses)  { create_list(:status, 2, private_flag: false) }
        let!(:private_statuses) { create_list(:status, 2, private_flag: true) }

        it do
          subject
          expect(response.parsed_body.map(&:deep_symbolize_keys)).to contain_exactly(*public_statuses.map(&:as_json))
        end
      end

      context "with no params specified" do
        let(:year)    { nil }
        let(:month)   { nil }
        let(:day)     { nil }
        let(:page)    { nil }

        before { travel_to(Time.now.utc) }
        after  { travel_back }

        let(:expected_per_page) { 10 }

        let!(:statuses) do
          # register statuses from newest to oldest
          (0..).first(expected_per_page + 1).map do |seconds_ago|
            tweeted_at = Time.now.utc - seconds_ago.seconds
            create(:status, tweeted_at: tweeted_at.to_i)
          end
        end

        it "returns at most 10 of the statuses tweeted before or eq to Time.now" do
          subject
          expect(response.parsed_body.map(&:deep_symbolize_keys)).to contain_exactly(*statuses.first(expected_per_page).map(&:as_json))
        end
      end
    end
  end
end
