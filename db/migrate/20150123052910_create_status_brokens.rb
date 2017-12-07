class CreateStatusBrokens < ActiveRecord::Migration
  def change
    create_table :status_brokens do |t|
      t.integer :status_id
      t.string :current_state
      t.boolean :solved
      t.integer :created_at
      t.integer :updated_at

      t.timestamps
    end
  end
end
