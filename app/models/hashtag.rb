# frozen_string_literal: true

class Hashtag < ApplicationRecord
  belongs_to :status

  include IndicesValidatable
  validates :text, presence: true, length: { maximum: 255 }
end
