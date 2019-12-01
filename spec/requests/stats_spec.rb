# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Stats", type: :request do
  describe "GET /stats" do
    subject { get stats_path, xhr: true }

    context "fails to fetch status count" do
      before do
        allow(StatusCount).to receive(:current_count).and_raise(Redis::CannotConnectError)
        subject
      end
      it_behaves_like "respond with status code", :internal_server_error
    end

    context "succeeds to fetch status count" do
      context "fails to fetch user count" do
        before do
          create_list(:status, 2)
          StatusCount.count_up

          allow(User).to receive(:count).and_raise
          subject
        end
        it_behaves_like "respond with status code", :internal_server_error
      end
      context "succeeds to fetch user count" do
        context "returned numbers are smaller than 1,000" do
          let(:total_status_count) { total_user_count }
          let(:total_user_count)   { 2 }
          before do
            users = create_list(:user, total_user_count)

            users.each { |user| create(:status, user: user) }
            StatusCount.count_up

            subject
          end

          it_behaves_like "respond with status code", :ok
          it do
            expect(response.body).to eq({
              status_count: total_status_count.to_s,
              user_count:   total_user_count.to_s,
            }.to_json)
          end
        end
        context "returned numbers are bigger than 1,000" do
          let(:total_status_count) { 2_000 }
          let(:total_user_count)   { 1_000 }
          before do
            allow(User).to receive(:count).and_return(total_user_count)
            allow(StatusCount).to receive(:current_count).and_return(total_status_count)
            subject
          end

          it_behaves_like "respond with status code", :ok
          it "returns delimited numbers" do
            expect(response.body).to eq({
              status_count: total_status_count.to_s(:delimited),
              user_count:   total_user_count.to_s(:delimited),
            }.to_json)
          end
        end
      end
    end
  end
end
