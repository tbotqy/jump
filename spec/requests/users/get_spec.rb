# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Users", type: :request do
  describe "GET /users/:id" do
    context "id is not given" do
      subject { get user_path(id: id) }
      let!(:user) { create(:user) }
      let(:id)    { "" }
      it { expect { subject }.to raise_error }
    end
    context "id is given" do
      context "user has not been authenticated" do
        let(:user) { create(:user) }
        let(:id)   { user.id }
        before { get user_path(id: id) }
        it_behaves_like "respond with status code", :unauthorized
      end
      context "user has been authenticated" do
        context "user with given id doesn't exist" do
          let!(:user)         { create(:user) }
          let(:other_user_id) { User.maximum(:id) + 1 }
          before do
            sign_in user
            get user_path(id: other_user_id)
          end
          it_behaves_like "respond with status code", :not_found
        end
        context "user with given id exists" do
          context "given id isn't an authenticated user's id" do
            let(:user)          { create(:user) }
            let(:other_user_id) { create(:user).id }
            before do
              sign_in user
              get user_path(id: other_user_id)
            end
            it_behaves_like "request for the others' resource"
          end
          context "given id is an authenticated user's id" do
            let(:name)              { "name" }
            let(:screen_name)       { "screen_name" }
            let(:profile_image_url) { "profile_image_url" }
            let(:status_count)      { 10 }
            let(:followee_count)    { 20 }
            let(:user) do
              create(:user,
                :with_statuses_and_followees,
                name:                    name,
                screen_name:             screen_name,
                profile_image_url_https: profile_image_url,
                status_count:            status_count,
                followee_count:          followee_count
              )
            end
            let(:id) { user.id }
            before do
              sign_in user
              get user_path(id: id)
            end

            it_behaves_like "respond with status code", :ok
            it do
              expect(response.body).to eq({
                name:              name,
                screen_name:       screen_name,
                profile_image_url: profile_image_url,
                status_count:      status_count,
                followee_count:    followee_count
              }.to_json)
            end
          end
        end
      end
    end
  end
end
