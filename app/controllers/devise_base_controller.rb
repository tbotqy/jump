# frozen_string_literal: true

class DeviseBaseController < ActionController::Base
  private

    def after_sign_out_path_for(resource_or_scope)
      service_top_url
    end
end
