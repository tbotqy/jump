# frozen_string_literal: true

require "rails_helper"

describe CollectUserStatusesService do
  describe ".call!" do
    subject { CollectUserStatusesService.call!(user_id: user_id, year: year, month: month, day: day, page: page) }

    shared_examples "raises Errors::NotFound error" do
      it { expect { subject }.to raise_error(Errors::NotFound, "No status found.") }
    end

    context "targeting user was not found" do
      # set params
      let!(:user)   { create(:user) }
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
          shared_context "user has 3 statuses tweeted around the boundary_time" do
            let(:boundary_unixtime) { boundary_time.to_i }
            let!(:status_tweeted_before_boundary) do
              status = create(:status, user: user, text: "to be ordered as 2nd item", tweeted_at: boundary_unixtime - 1)
              create_list(:entity, 2, status: status)
              status
            end
            let!(:status_tweeted_at_boundary) do
              # specifying larger id than status_tweeted_before_boundary has, in order to test the sort of fetched collection.
              id = status_tweeted_before_boundary.id + 1
              status = create(:status, id: id, user: user, text: "to be ordered as 1st item",  tweeted_at: boundary_unixtime)
              create_list(:entity, 2, status: status)
              status
            end
            let!(:status_tweeted_after_boundary) do
              status = create(:status, user: user, text: "to be filtered", tweeted_at: boundary_unixtime + 1)
              create_list(:entity, 2, status: status)
              status
            end
          end

          shared_examples "only includes those statuses that are tweeted at or before boundary time" do
            it { is_expected.to contain_exactly(status_tweeted_before_boundary, status_tweeted_at_boundary) }
          end

          describe "yearly search" do
            describe "it only returns the statuses that have been tweeted at or before the end of specified year" do
              let(:user) { create(:user) }

              # pre-register user's statuses
              let(:boundary_time) { Time.zone.local(year).end_of_year }
              include_context "user has 3 statuses tweeted around the boundary_time"

              let(:user_id) { user.id }
              let(:year)    { 2019 }
              let(:month)   { nil }
              let(:day)     { nil }
              let(:page)    { 1 }

              include_examples "only includes those statuses that are tweeted at or before boundary time"
            end
          end

          describe "monthly search" do
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

              include_examples "only includes those statuses that are tweeted at or before boundary time"
            end
          end
        end

        describe "pagination and order" do
          let!(:user) { create(:user) }
          before do
            # Register the statuses tweeted in ending of the specified date.
            # To test if the sort is applied, registering in random order, by using #shuffle.
            (1..15).to_a.shuffle.each do |seconds_ago|
              tweeted_at = (Time.zone.local(year, month, day).end_of_day - seconds_ago.seconds).to_i
              create(:status, user: user, text: "#{seconds_ago}th-new status", tweeted_at: tweeted_at)
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

        describe "user scope should be applied" do
          let(:targeted_user)     { create(:user) }
          let(:non_targeted_user) { create(:user) }
          let!(:targeted_user_statuses)     { create_list(:status, 2, user: targeted_user) }
          let!(:non_targeted_user_statuses) { create_list(:status, 2, user: non_targeted_user) }

          let(:user_id) { targeted_user.id }
          let(:year)    { nil }
          let(:month)   { nil }
          let(:day)     { nil }
          let(:page)    { nil }
          it { is_expected.to contain_exactly(*targeted_user_statuses) }
        end

        describe "both public and private statuses are collected" do
          let!(:user)   { create(:user) }
          let(:user_id) { user.id }
          let(:year)    { nil }
          let(:month)   { nil }
          let(:day)     { nil }
          let(:page)    { nil }
          context "user's statuses are public" do
            let!(:public_statuses) { create_list(:status, 2, private_flag: false, user: user) }
            it { is_expected.to contain_exactly(*public_statuses) }
          end
          context "user's statuses are private" do
            let!(:private_statuses) { create_list(:status, 2, private_flag: true, user: user) }
            it { is_expected.to contain_exactly(*private_statuses) }
          end
        end

        context "with no params specified" do
          let!(:user)   { create(:user) }
          let(:user_id) { user.id }
          let(:year)    { nil }
          let(:month)   { nil }
          let(:day)     { nil }
          let(:page)    { nil }

          before { travel_to(Time.current) }
          after  { travel_back }

          let(:expected_per_page) { 10 }

          let!(:user_statuses) do
            # register statuses from newest to oldest
            (0..).first(expected_per_page + 1).map do |seconds_ago|
              tweeted_at = Time.current - seconds_ago.seconds
              create(:status, user: user, tweeted_at: tweeted_at.to_i)
            end
          end

          it "returns at most 10 of the statuses tweeted before or eq to Time.current" do
            is_expected.to contain_exactly(*user_statuses.first(expected_per_page))
          end
        end
      end
    end
  end
end
