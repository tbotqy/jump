class DropEntities < ActiveRecord::Migration[6.0]
  def up
    drop_table :entities
  end

  def down; end
end
