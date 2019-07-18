# frozen_string_literal: true

namespace :delete_duplicated_followees do
  desc "delete duplicated followees"
  task start: :environment do
    con    = ActiveRecord::Base.connection
    result = con.select_all("select user_id, twitter_id, count(twitter_id) as count from followees group by user_id, twitter_id having count(twitter_id) >= 2")
    progress_bar = ProgressBar.create(total: result.count, format: "%t: |%B| %a %E  %c/%C %P%%")
    ActiveRecord::Base.transaction do
      result.each do |row|
        user_id    = row.fetch("user_id")
        twitter_id = row.fetch("twitter_id")
        count      = row.fetch("count")
        followees = Followee.where(user_id: user_id, twitter_id: twitter_id)
        raise "Trying to destroy unique record!" if followees.count == 1
        followees.last(count - 1).each(&:destroy!)
        raise "Destroying all the reocrds of user!" unless followees.reload.exists?
        progress_bar.increment
      end
    end
  end
end
