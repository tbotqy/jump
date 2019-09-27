# frozen_string_literal: true

class AddFkConstraintOnStatuses < ActiveRecord::Migration[5.2]
  def change
    add_foreign_key :statuses, :users
  end
end
