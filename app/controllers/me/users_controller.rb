# frozen_string_literal: true

module Me
  class UsersController < ApplicationController
    before_action :authenticate_user!

    # GET /me
    def show
      render json: current_user
    end

    # DELETE /me
    def destroy
      DestroyUserJob.perform_later(user_id: current_user.id)
      sign_out current_user
      head :accepted
    end
  end
end
