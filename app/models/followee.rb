# frozen_string_literal: true

class Followee < ApplicationRecord
  belongs_to :user

  validates :twitter_id, numericality: true, length: { maximum: 20 }
end
