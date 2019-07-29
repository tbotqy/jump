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
            # pre-register user's statuses
            let(:boundary_time) { Time.local(year).end_of_year }
            include_context "there are 3 public statuses tweeted around the boundary_time"

            let(:year)  { 2019 }
            let(:month) { nil }
            let(:day)   { nil }
            let(:page)  { 1 }

            before { subject }

            include_examples "examples"
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

            include_examples "examples"
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

            include_examples "examples"
          end
        end
      end

      describe "filtering by private flag" do
        let(:year)  { 2019 }
        let(:month) { 7 }
        let(:day)   { 4 }
        let(:page)  { 1 }

        let(:specified_time)    { Time.local(year, month, day).end_of_day }
        let!(:public_statuses)  { (1..3).to_a.map { |i| create(:status, private_flag: false, text: "public  status", tweeted_at: specified_time.to_i, tweet_id: i) } }
        let!(:private_statuses) { (4..6).to_a.map { |i| create(:status, private_flag: true,  text: "private status", tweeted_at: specified_time.to_i, tweet_id: i) } }
        before { subject }
        it "only returns public statuses" do
          texts_in_public_statuses = public_statuses.map(&:text)
          expect(response.parsed_body.map { |item| item["text"] }).to contain_exactly(*texts_in_public_statuses)
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
