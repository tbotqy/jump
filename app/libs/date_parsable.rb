# frozen_string_literal: true

module DateParsable
  extend ActiveSupport::Concern
  included do
    delegate :date_specified?, :last_moment_of_params!, to: :date_parser

    def date_parser
      @date_parser ||= DateParser.new(year, month, day)
    end
  end
end
