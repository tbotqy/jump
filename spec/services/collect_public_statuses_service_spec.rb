# frozen_string_literal: true

require "rails_helper"

describe CollectPublicStatusesService do
  describe ".call!" do
    subject { CollectPublicStatusesService.call!(year: year, month: month, day: day, page: page) }

    shared_examples "raises Errors::NotFound error" do
      it { expect { subject }.to raise_error(Errors::NotFound, "No status found.") }
    end

    context "no status exists" do
      let(:year)  { 2019 }
      let(:month) { 10 }
      let(:day)   { 1 }
      let(:page)  { 1 }
      it_behaves_like "raises Errors::NotFound error"
    end
    context "some statuses exist" do
      describe "boundary test on date-search" do
        shared_context "there are 3 public statuses tweeted around the boundary_time" do
          let(:boundary_unixtime) { boundary_time.to_i }
          let!(:status_tweeted_before_boundary) do
            status = create(:status, text: "to be ordered as 2nd item", private_flag: false, twitter_created_at: boundary_unixtime - 1)
            create_list(:entity, 2, status: status)
            status
          end
          let!(:status_tweeted_at_boundary) do
            # specifying larger id than status_tweeted_before_boundary has, in order to test the sort of fetched collection.
            id = status_tweeted_before_boundary.id + 1
            status = create(:status, id: id, text: "to be ordered as 1st item", private_flag: false, twitter_created_at: boundary_unixtime)
            create_list(:entity, 2, status: status)
            status
          end
          let!(:status_tweeted_after_boundary) do
            status = create(:status, text: "to be filtered", private_flag: false, twitter_created_at: boundary_unixtime + 1)
            create_list(:entity, 2, status: status)
            status
          end
        end

        shared_examples "only includes those statuses that are tweeted at or before boundary time" do
          it { is_expected.to contain_exactly(status_tweeted_before_boundary, status_tweeted_at_boundary) }
        end

        describe "yearly search" do
          describe "it only returns the statuses that have been tweeted at or before the end of specified year" do
            # pre-register user's statuses
            let(:boundary_time) { Time.local(year).end_of_year }
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
            let(:boundary_time) { Time.local(year, month).end_of_month }
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
            let(:boundary_time) { Time.local(year, month, day).end_of_day }
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
          (1..15).to_a.shuffle.each do |seconds_ago|
            tweeted_at = Time.local(year, month, day).end_of_day - seconds_ago.seconds
            create(:status, text: "#{seconds_ago}th-new status", private_flag: false, twitter_created_at: tweeted_at.to_i)
          end
        end

        let(:year)  { 2019 }
        let(:month) { 3 }
        let(:day)   { 20 }
        context "status to show exists" do
          context "page 1" do
            let(:page) { 1 }
            describe "number of return values" do
              it "returns as much as 10 (the maximum number for a page) statuses" do
                expect(subject.count).to eq 10
              end
            end
            describe "sort under the pagination" do
              it "includes first 10 statuses, ordered in new-tweet-first" do
                expected_status_texts_with_expected_order = (1..10).map { |nth| "#{nth}th-new status" }
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
                expected_status_texts_with_expected_order = (11..15).map { |nth| "#{nth}th-new status" }
                expect(subject.pluck(:text)).to eq expected_status_texts_with_expected_order
              end
            end
          end
        end
        context "paging to a blank page" do
          context "page 3" do
            let(:page) { 3 }
            it_behaves_like "raises Errors::NotFound error"
          end
        end
      end

      describe "filtering by private_flag" do
        let(:year)  { 2019 }
        let(:month) { 3 }
        let(:day)   { 20 }
        let(:page)  { 1 }

        let(:specified_time)    { Time.local(year, month, day).end_of_day }
        let!(:public_statuses)  { create_list(:status, 3, private_flag: false, twitter_created_at: specified_time.to_i) }
        let!(:private_statuses) { create_list(:status, 3, private_flag: true,  twitter_created_at: specified_time.to_i) }

        it "only returns public statuses" do
          is_expected.to contain_exactly(*public_statuses)
        end
      end
    end
  end
end
