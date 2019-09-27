class AddUniqueIndexToUserIdOnTweetImportProgresses < ActiveRecord::Migration[5.2]
  def up
    add_index :tweet_import_progresses, :user_id, unique: true
  end
end
