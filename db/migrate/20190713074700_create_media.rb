class CreateMedia < ActiveRecord::Migration[5.2]
  def change
    create_table :media do |t|
      t.belongs_to :status, foreign_key: true, null: false
      t.string :url, null: false
      t.string :direct_url, null: false
      t.string :display_url, null: false
      t.integer :index_f, null: false
      t.integer :index_l, null: false

      t.timestamps
    end
  end
end
