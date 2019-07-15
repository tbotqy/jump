class CreateHashtags < ActiveRecord::Migration[5.2]
  def change
    create_table :hashtags do |t|
      t.belongs_to :status, foreign_key: true, null: false
      t.string :hashtag, null: false
      t.integer :index_f, null: false
      t.integer :index_l, null: false

      t.timestamps
    end
  end
end
