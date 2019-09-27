# frozen_string_literal: true

class UserUpdateFailLog < ApplicationRecord
  belongs_to :user

  validates :error_message, presence: true, length: { maximum: 255 }
end
