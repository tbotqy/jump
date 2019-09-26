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
      let(:total_status_count) { 3 }
      before do
        create_list(:status, total_status_count)
        StatusCount.count_up
        subject
      end
      it_behaves_like "respond with status code", :ok
      it do
        expect(response.body).to eq({ status_count: total_status_count.to_s(:delimited) }.to_json)
      end
    end
  end
end
