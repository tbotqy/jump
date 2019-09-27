class RenameStatusIdStrToTweetIdOnStatuses < ActiveRecord::Migration[5.2]
  def change
    rename_column :statuses, :status_id_str,             :tweet_id
    rename_column :statuses, :in_reply_to_status_id_str, :in_reply_to_tweet_id
    rename_column :statuses, :status_id_str_reversed,    :tweet_id_reversed
  end
end
