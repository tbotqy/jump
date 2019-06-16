# frozen_string_literal: true

require "rails_helper"

RSpec.describe "User authentication", type: :request do
  describe "GET /users/auth/twitter" do
    before { get user_twitter_omniauth_authorize_path }
    describe "lead the user to authorize our app and finally get back to our callback action" do
      it { expect(response).to have_http_status(302) }
      it { expect(response.location).to include("/users/auth/twitter/callback") }
    end
  end
end
