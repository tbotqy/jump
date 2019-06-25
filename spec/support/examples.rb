# frozen_string_literal: true

shared_examples "respond with status code" do |status_code|
  it { expect(response).to have_http_status(status_code) }
end

shared_examples "response body has error messages" do |error_messages|
  it { expect(response.body).to eq({ messages: Array.wrap(error_messages) }.to_json) }
end

shared_examples "unauthenticated request" do
  it_behaves_like "respond with status code", :unauthorized
end

shared_examples "request for the others' resource" do
  it_behaves_like "respond with status code", :unauthorized
  it_behaves_like "response body has error messages", "Attempting to operate on other's resource."
end

shared_examples "a scope" do
  it { expect(subject).to be_an(ActiveRecord::Relation) }
end
