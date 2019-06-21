# frozen_string_literal: true

class RemoveManuallyNamedIndexForStatusIdOnEntities < ActiveRecord::Migration[5.2]
  def up
    remove_index :entities, name: :status_id
  end

  def down
    add_index :entities, :status_id, name: :status_id
  end
end
