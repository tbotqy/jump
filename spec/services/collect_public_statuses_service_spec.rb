# frozen_string_literal: true

require "rails_helper"

describe CollectPublicStatusesService do
  describe ".call!" do
    subject { CollectPublicStatusesService.call!(year: year, month: month, day: day, page: page) }

    context "no status exists" do
      let(:year)  { 2019 }
      let(:month) { 10 }
      let(:day)   { 1 }
      let(:page)  { 1 }
      it { is_expected.to be_empty }
    end
    context "some statuses exist" do
      describe "boundary test on date-search" do
        shared_context "there are 3 public statuses tweeted around the boundary_time" do
          let(:boundary_unixtime) { boundary_time.to_i }
          let!(:status_tweeted_before_boundary) do
            create(:status, text: "to be ordered as 2nd item", protected_flag: false, tweeted_at: boundary_unixtime - 1)
          end
          let!(:status_tweeted_at_boundary) do
            # specifying larger id than status_tweeted_before_boundary has, in order to test the sort of fetched collection.
            id = status_tweeted_before_boundary.id + 1
            create(:status, id: id, text: "to be ordered as 1st item", protected_flag: false, tweeted_at: boundary_unixtime)
          end
          let!(:status_tweeted_after_boundary) do
            create(:status, text: "to be filtered", protected_flag: false, tweeted_at: boundary_unixtime + 1)
          end
        end

        shared_examples "only includes those statuses that are tweeted at or before boundary time" do
          it { is_expected.to contain_exactly(status_tweeted_before_boundary, status_tweeted_at_boundary) }
        end

        describe "yearly search" do
          describe "it only returns the statuses that have been tweeted at or before the end of specified year" do
            # pre-register user's statuses
            let(:boundary_time) { Time.zone.local(year).end_of_year }
            include_context "there are 3 public statuses tweeted around the boundary_time"

            let(:year)  { 2019 }
            let(:month) { nil }
            let(:day)   { nil }
            let(:page)  { 1 }

            include_examples "only includes those statuses that are tweeted at or before boundary time"
          end
        end

        describe "monthly search" do
          describe "it only returns the statuses that have been tweeted (at or before) the end of specified month" do
            # pre-register user's statuses
            let(:boundary_time) { Time.zone.local(year, month).end_of_month }
            include_context "there are 3 public statuses tweeted around the boundary_time"

            let(:year)  { 2019 }
            let(:month) { 3 }
            let(:day)   { nil }
            let(:page)  { 1 }

            include_examples "only includes those statuses that are tweeted at or before boundary time"
          end
        end

        describe "daily search" do
          describe "it only returns the statuses that have been tweeted (at or before) the end of specified day" do
            # pre-register user's statuses
            let(:boundary_time) { Time.zone.local(year, month, day).end_of_day }
            include_context "there are 3 public statuses tweeted around the boundary_time"

            let(:year)  { 2019 }
            let(:month) { 3 }
            let(:day)   { 20 }
            let(:page)  { 1 }

            include_examples "only includes those statuses that are tweeted at or before boundary time"
          end
        end
      end

      describe "pagination and order" do
        before do
          # Register the statuses tweeted in ending of the specified date.
          # To test if the sort is applied, registering in random order, by using #shuffle.
          (1..30).to_a.shuffle.each do |seconds_ago|
            tweeted_at = (Time.zone.local(year, month, day).end_of_day - seconds_ago.seconds).to_i
            create(:status, text: "#{seconds_ago}th-new status", protected_flag: false, tweeted_at: tweeted_at)
          end
        end

        let(:year)  { 2019 }
        let(:month) { 3 }
        let(:day)   { 20 }
        context "status to show exists" do
          context "page 1" do
            let(:page) { 1 }
            describe "number of return values" do
              it "returns as much as 25 (the maximum number for a page) statuses" do
                expect(subject.count).to eq 25
              end
            end
            describe "sort under the pagination" do
              it "includes first 25 statuses, ordered in new-tweet-first" do
                expected_status_texts_with_expected_order = (1..25).map { |nth| "#{nth}th-new status" }
                expect(subject.pluck(:text)).to eq expected_status_texts_with_expected_order
              end
            end
          end
          context "page 2" do
            let(:page) { 2 }
            describe "number of return values" do
              it "returns as much as 5 (the number of statuses in 2nd page) statuses" do
                expect(subject.count).to eq 5
              end
            end
            describe "sort under the pagination" do
              it "includes last 5 statuses, ordered in new-tweet-first" do
                expected_status_texts_with_expected_order = (26..30).map { |nth| "#{nth}th-new status" }
                expect(subject.pluck(:text)).to eq expected_status_texts_with_expected_order
              end
            end
          end
        end
        context "paging to a blank page" do
          context "page 3" do
            let(:page) { 3 }
            it { is_expected.to be_empty }
          end
        end
      end

      describe "filtering by protected_flag" do
        let(:year)  { 2019 }
        let(:month) { 3 }
        let(:day)   { 20 }
        let(:page)  { 1 }

        let(:specified_time)    { Time.zone.local(year, month, day).end_of_day }
        let!(:public_statuses)  { (1..3).to_a.map { |i| create(:status, protected_flag: false, tweeted_at: specified_time.to_i, tweet_id: i) } }
        let!(:protected_statuses) { (4..6).to_a.map { |i| create(:status, protected_flag: true,  tweeted_at: specified_time.to_i, tweet_id: i) } }

        it "only returns public statuses" do
          is_expected.to contain_exactly(*public_statuses)
        end
      end

      context "with no params specified" do
        let(:year)    { nil }
        let(:month)   { nil }
        let(:day)     { nil }
        let(:page)    { nil }

        let(:expected_per_page) { 25 }

        let!(:statuses) do
          # register statuses from newest to oldest
          now = Time.current
          (0..).first(expected_per_page + 1).map do |seconds_ago|
            tweeted_at = now - seconds_ago.seconds
            create(:status, tweeted_at: tweeted_at.to_i)
          end
        end

        it "returns at most 25 of the statuses" do
          is_expected.to contain_exactly(*statuses.first(expected_per_page))
        end
      end
    end
  end
end
