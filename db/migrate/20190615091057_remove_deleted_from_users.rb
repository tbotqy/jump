# frozen_string_literal: true

class RemoveDeletedFromUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :deleted, :boolean, null: false, default: false, after: :closed_only
  end
end
