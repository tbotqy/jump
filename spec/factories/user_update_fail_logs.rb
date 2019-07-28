# frozen_string_literal: true

FactoryBot.define do
  factory :user_update_fail_log do
    user
    error_message { "error message" }
  end
end
