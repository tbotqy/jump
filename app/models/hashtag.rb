# frozen_string_literal: true

class Hashtag < ApplicationRecord
  belongs_to :status

  include IndexValidations
  validates :hashtag, presence: true, length: { maximum: 255 }
end
