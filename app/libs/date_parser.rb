# frozen_string_literal: true

class DateParser
  def initialize(year, month, day)
    @year  = year
    @month = month
    @day   = day
  end

  def date_specified?
    [year, month, day].any?(&:present?)
  end

  def last_moment_of_params!
    if [year, month, day].all?(&:present?)
      # (2019, 3, 10).end_of_day
      Time.zone.local(year, month, day).end_of_day
    elsif [year, month].all?(&:present?)
      # (2019, 3).end_of_month
      Time.zone.local(year, month).end_of_month
    elsif year.present? && day.blank?
      # 2019.end_of_year
      Time.zone.local(year).end_of_year
    else
      raise Errors::InvalidParam, "Given date(year: #{year}, month: #{month}, day: #{day}) is incomplete to be parsed to Time."
    end
  end

  private
    attr_reader :year, :month, :day
end
