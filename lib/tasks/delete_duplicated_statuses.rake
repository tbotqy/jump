# frozen_string_literal: true

namespace :delete_duplicated_statuses do
  desc "delete duplicating statuses"
  task start: :environment do
    con    = ActiveRecord::Base.connection
    result = con.select_all("select tweet_id, count(tweet_id) as count from statuses group by tweet_id having count(tweet_id) >= 2")
    progress_bar = ProgressBar.create(total: result.count, format: "%t: |%B| %a %E  %c/%C %P%%")
    ActiveRecord::Base.transaction do
      result.each do |row|
        tweet_id = row.fetch("tweet_id")
        count    = row.fetch("count")
        case count
        when 2
          Status.where(tweet_id: tweet_id).last.destroy!
        when 3
          Status.where(tweet_id: tweet_id).last(2).each(&:destroy!)
        else
          raise "unexpected case: count=#{count}"
        end
        progress_bar.increment
      end
    end
  end
end
