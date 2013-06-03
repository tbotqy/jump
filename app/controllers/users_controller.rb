class UsersController < ApplicationController
  def index
    @total_status_num = Status.get_total_status_num
  end

  def show
  end
end
