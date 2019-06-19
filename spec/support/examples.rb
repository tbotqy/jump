# frozen_string_literal: true

shared_examples "respond with status code" do |status_code|
  it { expect(response).to have_http_status(status_code) }
end

shared_examples "response body has error messages" do |error_messages|
  it { expect(response.body).to eq({ messages: Array.wrap(error_messages) }.to_json) }
end
