# frozen_string_literal: true

class CollectUserStatusesService
  private_class_method :new

  class << self
    def call!(user_id:, year: nil, month: nil, day: nil, page: 1)
      new(user_id, year, month, day, page).send(:call!)
    end
  end

  private
    include DateParsable

    def initialize(user_id, year, month, day, page)
      @user_id  = user_id
      @year     = year
      @month    = month
      @day      = day
      @page     = page
      @collection = []
    end

    attr_reader :user_id, :year, :month, :day, :page

    def call!
      fetch_user_statuses_all!
      scope_by_date if date_specified?
      apply_pagination
      @collection.order_by_newest_to_oldest
    end

    def fetch_user_statuses_all!
      @collection = User.find(user_id).statuses.includes(:urls, :media)
    end

    def scope_by_date
      @collection = @collection.tweeted_at_or_before(last_moment_of_params!)
    end

    def apply_pagination
      @collection = @collection.page(page)
    end
end
