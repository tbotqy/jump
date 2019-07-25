class RemoveCountFromTweetImportProgresses < ActiveRecord::Migration[5.2]
  def change
    remove_column :tweet_import_progresses, :count, :integer, null: false, default: 0, after: :user_id
  end
end
