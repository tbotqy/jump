# frozen_string_literal: true

class Hashtag < ApplicationRecord
  belongs_to :status

  validates :hashtag, presence: true, length: { maximum: 255 }
  validates :index_f, numericality: { only_integer: true }
  validates :index_l, numericality: { only_integer: true }
end
