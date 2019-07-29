class CreateTweetImportLocks < ActiveRecord::Migration[5.2]
  def change
    create_table :tweet_import_locks do |t|
      t.belongs_to :user, foreign_key: true, null: false, index: { unique: true }

      t.timestamps
    end
  end
end
