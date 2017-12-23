class DropStatusIdStrFromEntity < ActiveRecord::Migration
  def change
    remove_column :entities, :status_id_str
  end
end
