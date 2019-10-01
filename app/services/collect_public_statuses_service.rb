# frozen_string_literal: true

class CollectPublicStatusesService
  private_class_method :new

  class << self
    def call!(year: nil, month: nil, day: nil, page: 1)
      new(year, month, day, page).send(:call!)
    end
  end

  private
    include DateParsable

    def initialize(year, month, day, page)
      @year     = year
      @month    = month
      @day      = day
      @page     = page
      @collection = []
    end

    attr_reader :year, :month, :day, :page

    def call!
      fetch_public_statuses_all
      scope_by_date if date_specified?
      apply_pagination
      check_if_collection_exists!
      @collection.order_by_newest_to_oldest
    end

    def fetch_public_statuses_all
      @collection = Status.not_protected.includes(:user, :urls, :media)
    end

    def scope_by_date
      @collection = @collection.tweeted_at_or_before(last_moment_of_params!)
    end

    def apply_pagination
      @collection = @collection.page(page)
    end

    def check_if_collection_exists!
      raise Errors::NotFound, "No status found." unless @collection.use_index("index_statuses_for_public_timeline").exists?
    end
end
