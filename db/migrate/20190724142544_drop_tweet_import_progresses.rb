class DropTweetImportProgresses < ActiveRecord::Migration[5.2]
  def change
    drop_table :tweet_import_progresses do |t|
      t.belongs_to :user,  foreign_key: true, null: false, index: { unique: true }
      t.integer :count,    null: false, default: 0
      t.boolean :finished, null: false, default: 0
      t.timestamps
    end
  end
end
