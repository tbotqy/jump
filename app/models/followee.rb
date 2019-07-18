# frozen_string_literal: true

class Followee < ApplicationRecord
  belongs_to :user

  validates :twitter_id, presence: true, uniqueness: { scope: :user_id }, numericality: { only_integer: true }
end
