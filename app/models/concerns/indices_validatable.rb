# frozen_string_literal: true

module IndicesValidatable
  extend ActiveSupport::Concern
  included do
    validates :index_f, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
    validates :index_l, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  end
end
