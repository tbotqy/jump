# frozen_string_literal: true

class TweetImportLock < ApplicationRecord
  belongs_to :user

  validates :user_id, uniqueness: true
end
