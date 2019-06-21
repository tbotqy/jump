# frozen_string_literal: true

class RemoveStaleIndexOnStatuses < ActiveRecord::Migration[5.2]
  def up
    %i|
      idx_tcar_sisr_on_statuses
      idx_u_tcar_on_statuses
      idx_sisr_on_statuses
      index_statuses_on_tweeted_on_and_deleted_and_private
    |.each do |index_name|
      remove_index :statuses, name: index_name
    end
  end

  def down; end
end
