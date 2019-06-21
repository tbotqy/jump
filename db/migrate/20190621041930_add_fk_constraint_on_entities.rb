# frozen_string_literal: true

class AddFkConstraintOnEntities < ActiveRecord::Migration[5.2]
  def up
    add_foreign_key :entities, :statuses
  end

  def down
    remove_foreign_key :entities, :statuses
    remove_index       :entities, :status_id # index for status_id has not been set before this migration
  end
end
