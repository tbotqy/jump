class DropStatusBrokens < ActiveRecord::Migration
  def change
    drop_table :status_brokens
  end
end
