# frozen_string_literal: true

require "rails_helper"

RSpec.describe ApplicationController, type: :controller do
  controller(ApplicationController) do
    def index
      render nothing: true
    end
  end

  describe "#reject_non_ajax!" do
    context "request is an XHR" do
      before { get :index, xhr: true }
      it_behaves_like "respond with status code", :ok
    end
    context "request is not an XHR " do
      before { get :index, xhr: false }
      it_behaves_like "respond with status code", :bad_request
    end
  end
end
