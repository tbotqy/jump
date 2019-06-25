# frozen_string_literal: true

require "rails_helper"

describe CollectUserStatusesService do
  describe ".call!" do
    subject { CollectUserStatusesService.call!(user_id: user_id, year: year, month: month, day: day, page: page) }

    shared_examples "raises Errors::NotFound error" do
      it { expect { subject }.to raise_error(Errors::NotFound, "No status found.") }
    end

    shared_context "pre-register a non-targeted user and its status" do
      let!(:non_targeted_user)        { create(:user) }
      let!(:non_targeted_user_status) { create(:status, user: non_targeted_user, twitter_created_at: Time.local(year, month, day).to_i) }
    end

    context "targeting user was not found" do
      include_context "pre-register a non-targeted user and its status"

      # set params
      let(:user_id) { User.maximum(:id) + 1 } # set not to point the existing user
      let(:year)    { 2019 }
      let(:month)   { 10 }
      let(:day)     { 1 }
      let(:page)    { 1 }
      it { expect { subject }.to raise_error(ActiveRecord::RecordNotFound, "Couldn't find User with 'id'=#{user_id}") }
    end
    context "targeting user was found" do
      context "user has no status at all" do
        let(:user_id) { create(:user).id } # set the id of the user who has no status
        let(:year)    { 2019 }
        let(:month)   { 10 }
        let(:day)     { 1 }
        let(:page)    { 1 }
        it_behaves_like "raises Errors::NotFound error"
      end
      context "user has some statuses" do
        describe "boundary test on date-search" do
          describe "yearly search" do
            describe "it only returns the statuses that have been tweeted at or before the end of specified year" do
              let(:user) { create(:user) }

              # pre-register user's statuses
              let(:specified_year) { Time.local(year).beginning_of_year }
              let!(:status_tweeted_at_end_of_year) do
                create(:status, user: user, twitter_created_at: specified_year.end_of_year.to_i)
              end
              let!(:status_tweeted_before_end_of_year) do
                create(:status, user: user, twitter_created_at: specified_year.end_of_year.to_i - 1)
              end
              let!(:status_tweeted_at_beginning_of_next_year) do
                create(:status, user: user, twitter_created_at: specified_year.next_year.beginning_of_year.to_i)
              end

              include_context "pre-register a non-targeted user and its status"

              let(:user_id) { user.id }
              let(:year)    { 2019 }
              let(:month)   { nil }
              let(:day)     { nil }
              let(:page)    { 1 }
              it { is_expected.to contain_exactly(status_tweeted_at_end_of_year, status_tweeted_before_end_of_year) }
            end
          end

          describe "monthly search" do
            let(:user) { create(:user) }

            # pre-register user's statuses
            let(:specified_month) { Time.local(year, month).beginning_of_month }
            let!(:status_tweeted_at_end_of_month) do
              create(:status, user: user, twitter_created_at: specified_month.end_of_month.to_i)
            end
            let!(:status_tweeted_before_end_of_month) do
              create(:status, user: user, twitter_created_at: specified_month.end_of_month.to_i - 1)
            end
            let!(:status_tweeted_at_beginning_of_next_month) do
              create(:status, user: user, twitter_created_at: specified_month.next_month.beginning_of_month.to_i)
            end

            let(:user_id) { user.id }
            let(:year)    { 2019 }
            let(:month)   { 3 }
            let(:day)     { nil }
            let(:page)    { 1 }
            it { is_expected.to contain_exactly(status_tweeted_at_end_of_month, status_tweeted_before_end_of_month) }
          end

          describe "daily search" do
            let(:user) { create(:user) }

            # pre-register user's statuses
            let(:specified_day) { Time.local(year, month, day).beginning_of_day }
            let!(:status_tweeted_at_end_of_day) do
              create(:status, user: user, twitter_created_at: specified_day.end_of_day.to_i)
            end
            let!(:status_tweeted_before_end_of_day) do
              create(:status, user: user, twitter_created_at: specified_day.end_of_day.to_i - 1)
            end
            let!(:status_tweeted_at_beginning_of_next_day) do
              create(:status, user: user, twitter_created_at: specified_day.next_day.beginning_of_day.to_i)
            end

            include_context "pre-register a non-targeted user and its status"

            let(:user_id) { user.id }
            let(:year)    { 2019 }
            let(:month)   { 3 }
            let(:day)     { 20 }
            let(:page)    { 1 }
            it { is_expected.to contain_exactly(status_tweeted_at_end_of_day, status_tweeted_before_end_of_day) }
          end
        end

        describe "pagination and order" do
          let!(:user) { create(:user) }
          before do
            # Register the statuses tweeted in ending of the specified date.
            # To test if the sort is applied, registering in random order, by using #shuffle.
            (1..15).to_a.shuffle.each do |seconds_ago|
              tweeted_at = Time.local(year, month, day).end_of_day - seconds_ago.seconds
              create(:status, user: user, text: "#{seconds_ago}th-new status", twitter_created_at: tweeted_at.to_i)
            end
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
      end
    end
  end
end
