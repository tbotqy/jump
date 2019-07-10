# frozen_string_literal: true

require "rails_helper"

describe FetchUserFolloweesService do
  describe ".call!" do
    subject { -> { described_class.call!(user_id: user_id) } }
    context "user with given user_id doesn't exist" do
      let!(:user)   { create(:user) }
      let(:user_id) { User.maximum(:id) + 1 }
      it { is_expected.to raise_error(ActiveRecord::RecordNotFound) }
    end
    context "user with given user_id exists" do
      let!(:user)   { create(:user) }
      let(:user_id) { user.id }
      context "failed to fetch user's followees" do
        before do
          allow_any_instance_of(Twitter::REST::Client).to receive(:friend_ids)
            .with(anything)
            .and_raise(Twitter::Error::TooManyRequests)
        end
        it { is_expected.to raise_error(Twitter::Error::TooManyRequests) }
      end
      context "succeeded to fetch user's followees" do
        let(:initial_cursor)  { -1 }
        let(:terminal_cursor) { 0 }
        context "user has no followee" do
          before do
            allow_any_instance_of(Twitter::REST::Client).to receive(:friend_ids)
              .with(cursor: initial_cursor).and_return(
                double("Twitter::Cursor", attrs: { ids: [], next_cursor: terminal_cursor })
              )
          end
          it { expect(subject.call).to eq [] }
        end
        context "user has some followees" do
          let!(:first_ids) { (1..10).to_a }
          let!(:last_ids)  { (11..20).to_a }
          let(:next_cursor_returned_by_first_request) { 10 }
          before do
            # stub the first API request
            allow_any_instance_of(Twitter::REST::Client).to receive(:friend_ids)
              .with(cursor: initial_cursor).and_return(
                double("Twitter::Cursor returned by the first request", attrs: { ids: first_ids, next_cursor: next_cursor_returned_by_first_request })
              )
            # stub the last API request
            allow_any_instance_of(Twitter::REST::Client).to receive(:friend_ids)
              .with(cursor: next_cursor_returned_by_first_request).and_return(
                double("Twitter::Cursor returned by the last request", attrs: { ids: last_ids, next_cursor: terminal_cursor })
              )
          end
          it { expect(subject.call).to contain_exactly(*(first_ids + last_ids)) }
        end
      end
    end
  end
end
