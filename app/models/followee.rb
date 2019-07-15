# frozen_string_literal: true

class Followee < ApplicationRecord
  belongs_to :user

  validates :twitter_id, numericality: { only_integer: true }
end
