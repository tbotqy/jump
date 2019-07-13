# frozen_string_literal: true

module IndexValidations
  extend ActiveSupport::Concern
  included do
    validates :index_f, numericality: { only_integer: true }
    validates :index_l, numericality: { only_integer: true }
  end
end
