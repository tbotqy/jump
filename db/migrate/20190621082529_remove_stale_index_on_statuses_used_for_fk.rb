# frozen_string_literal: true

class RemoveStaleIndexOnStatusesUsedForFk < ActiveRecord::Migration[5.2]
  def up
    remove_index :statuses, name: :idx_u_tcar_sisr_on_statuses
  end

  def down; end
end
