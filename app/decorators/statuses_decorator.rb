# frozen_string_literal: true

class StatusesDecorator < Draper::CollectionDecorator
  # returns an array like below
  # [ { "#{year}": [ { "#{month}": days } ] } ]
  def tweeted_dates
    tweeted_ons = object.distinct(:tweeted_on).order(tweeted_on: :desc).pluck(:tweeted_on)
    tweeted_ons.group_by(&:year).map do |year, dates_of_year|
      month_and_its_days = dates_of_year.group_by(&:month).map do |month, dates_of_month|
        { "#{month}": dates_of_month.map(&:day).map(&:to_s) }
      end
      { "#{year}": month_and_its_days }
    end
  end
end
