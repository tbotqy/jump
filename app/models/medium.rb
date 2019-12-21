# frozen_string_literal: true

class Medium < ApplicationRecord
  belongs_to :status

  include IndicesValidatable
  validates :url,         presence: true, length: { maximum: 255 }
  validates :direct_url,  length: { maximum: 255 }
  validates :display_url, presence: true, length: { maximum: 255 }

  def as_json(options = {})
    {
      url:        url,
      displayUrl: display_url,
      directUrl:  direct_url,
      indices: [
        index_f,
        index_l
      ]
    }.compact
  end
end
