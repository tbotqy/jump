class ProfileUpdateFailLog < ApplicationRecord
  class << self
    def log!(user_id, error_message)
      create!(
        user_id: user_id,
        error_message: error_message
      )
    end
  end
end
