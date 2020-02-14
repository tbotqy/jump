# frozen_string_literal: true

class CollectFolloweeStatusesService
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
      fetch_followee_statuses_all!
      scope_by_date if date_specified?
      apply_pagination
      @collection.order_by_newest_to_oldest
    end

    def fetch_followee_statuses_all!
      followees = User.where(twitter_id: User.find(user_id).followees.pluck(:twitter_id))
      raise Errors::NotFound, "User has no followee." unless followees.exists?
      @collection = Status.where(user: followees).includes(:user, :urls, :media)
    end

    def scope_by_date
      @collection = @collection.tweeted_at_or_before(last_moment_of_params!)
    end

    def apply_pagination
      @collection = @collection.page(page)
    end
end
