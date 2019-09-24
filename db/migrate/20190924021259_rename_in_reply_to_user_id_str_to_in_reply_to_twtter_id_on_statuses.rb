class RenameInReplyToUserIdStrToInReplyToTwtterIdOnStatuses < ActiveRecord::Migration[6.0]
  def change
    rename_column :statuses, :in_reply_to_user_id_str, :in_reply_to_twitter_id
  end
end
