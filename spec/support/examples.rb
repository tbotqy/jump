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

shared_examples "request for the other user's resource" do
  it_behaves_like "respond with status code", :unauthorized
  it_behaves_like "response body has error messages", "Attempting to operate on other's resource."
end

shared_examples "a scope" do
  it { expect(subject).to be_an(ActiveRecord::Relation) }
end

shared_examples "should validate before_type_cast is a boolean" do |model_name, attr_name|
  subject do
    record = build(model_name, "#{attr_name}": value)
    record.valid?
    record.errors.messages
  end
  context "valid" do
    [true, false].each do |valid_value|
      context valid_value do
        let(:value) { valid_value }
        it { is_expected.not_to have_key(:"#{attr_name}_before_type_cast") }
      end
    end
  end
  context "invalid" do
    shared_examples "includes error message" do |value_to_be_validated|
      context value_to_be_validated do
        let(:value) { value_to_be_validated }
        it { is_expected.to include("#{attr_name}_before_type_cast": ["is not included in the list"]) }
      end
    end
    context "numbers" do
      [0, 1].each do |invalid_value|
        it_behaves_like "includes error message", invalid_value
      end
    end
    context "strings" do
      ["0", "1", "true", "false"].each do |invalid_value|
        it_behaves_like "includes error message", invalid_value
      end
    end
  end
end
