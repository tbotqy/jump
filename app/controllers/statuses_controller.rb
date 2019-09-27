# frozen_string_literal: true

class StatusesController < ApplicationController
  def index
    statuses = CollectPublicStatusesService.call!(params_to_collect_by)
    render json: statuses
  end

  private
    def params_to_collect_by
      params.permit(:year, :month, :day, :page).to_h.symbolize_keys
    end
end
