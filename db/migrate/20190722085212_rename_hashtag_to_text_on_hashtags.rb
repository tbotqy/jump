class RenameHashtagToTextOnHashtags < ActiveRecord::Migration[5.2]
  def change
    rename_column :hashtags, :hashtag, :text
  end
end
