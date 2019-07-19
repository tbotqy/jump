# frozen_string_literal: true

module IndicesValidatable
  extend ActiveSupport::Concern
  included do
    validates :index_f, presence: true, numericality: { only_integer: true }
    validates :index_l, presence: true, numericality: { only_integer: true }
  end
end
