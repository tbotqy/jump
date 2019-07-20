# frozen_string_literal: true

namespace :delete_drifting_records do
  task start: :environment do
    puts "Deleting drifted followees"
    gone_user_ids = Followee.pluck(:user_id).uniq.select do |id|
      !User.exists?(id: id)
    end
    Followee.where(user_id: gone_user_ids).delete_all

    puts "Deleting drifted entities"
    all_status_ids    = Status.pluck(:id)
    entity_status_ids = Entity.pluck(:status_id).uniq
    gone_status_ids   = entity_status_ids - all_status_ids
    Entity.where(status_id: gone_status_ids).delete_all

    puts "Deleting all tweet_import_progresses"
    TweetImportProgress.delete_all
  end
end
