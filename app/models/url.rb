# frozen_string_literal: true

class Url < ApplicationRecord
  belongs_to :status

  include IndicesValidatable
  validates :url,         presence: true, length: { maximum: 255 }
  validates :display_url, presence: true, length: { maximum: 255 }
end
