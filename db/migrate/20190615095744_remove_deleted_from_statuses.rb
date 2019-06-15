# frozen_string_literal: true

class RemoveDeletedFromStatuses < ActiveRecord::Migration[5.2]
  def change
    remove_column :statuses, :deleted, :boolean, null: false, default: false, after: :private
  end
end
