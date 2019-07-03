# frozen_string_literal: true

class SearchStatusesService
  class << self
    def call!(user_id:, year: nil, month: nil, day: nil, page: 1)
      new(user_id, year, month, day, page).call!
    end
  end

  def initialize(user_id, year, month, day, page)
    @user_id  = user_id
    @year     = year
    @month    = month
    @day      = day
    @page     = page
    @collection = []
  end

  def call!
    fetch_user_statuses_all!
    scope_by_date if date_specified?
    apply_pagination
    check_if_collection_exists!
    @collection.order_for_timeline
  end

  private
    attr_reader :user_id, :year, :month, :day, :page

    delegate :date_specified?, :last_moment_of_params!, to: :date_parser

    def fetch_user_statuses_all!
      @collection = User.find(user_id).statuses.includes(:entities)
    end

    def scope_by_date
      @collection = @collection.tweeted_at_or_before(last_moment_of_params!)
    end

    def apply_pagination
      @collection = @collection.page(page)
    end

    def check_if_collection_exists!
      raise Errors::NotFound, "No status found." unless @collection.exists?
    end

    def date_parser
      @date_parser ||= SearchStatusesService::DateParser.new(year, month, day)
    end
end
