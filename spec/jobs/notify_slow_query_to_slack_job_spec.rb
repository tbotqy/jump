# frozen_string_literal: true

require "rails_helper"

RSpec.describe NotifySlowQueryToSlackJob, type: :job do
  subject       { ->  { described_class.perform_now(message: message) } }
  let(:message) { "some message" }

  let(:slack_notifier) { instance_double("Slack::Notifier", ping: nil) }
  before { allow(Slack::Notifier).to receive(:new).and_return(slack_notifier) }

  context "fails to fetch webhook url" do
    shared_examples "doesn't call slack api" do
      it do
        subject.call rescue nil
        expect(slack_notifier).not_to have_received(:ping)
      end
    end

    context "correspond key doesn't exist in .env" do
      before { allow(ENV).to receive(:fetch).with("SLACK_SLOW_QUERY_WEBHOOK_URL").and_raise(KeyError) }
      it { is_expected.to raise_error(KeyError) }
      it_behaves_like "doesn't call slack api"
    end
    context "fetched url is blank" do
      before { allow(ENV).to receive(:fetch).with("SLACK_SLOW_QUERY_WEBHOOK_URL").and_return("") }
      it { is_expected.to raise_error("A required env var（SLACK_SLOW_QUERY_WEBHOOK_URL）is not supplied.") }
      it_behaves_like "doesn't call slack api"
    end
  end
  context "succeeds to fetch webhook url" do
    before do
      allow(ENV).to receive(:fetch).with("SLACK_SLOW_QUERY_WEBHOOK_URL").and_return("webhook_url")
    end
    it { is_expected.not_to raise_error }
    it do
      subject.call
      expect(slack_notifier).to have_received(:ping).with(message).exactly(:once)
    end
  end
end
