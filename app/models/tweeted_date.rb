# frozen_string_literal: true

class TweetedDate
  class << self
    def by(timeline_type, user_id)
      new(timeline_type, user_id).target_object
    end
  end

  def initialize(timeline_type, user_id)
    @timeline_type = timeline_type
    @user_id       = user_id
  end

  def target_object
    case
    when @timeline_type.public_timeline?
      TweetedDate::Public.new
    when @timeline_type.user_timeline?
      TweetedDate::ByUser.new(@user_id)
    when @timeline_type.home_timeline?
      TweetedDate::ByUserFriend.new(@user_id)
    else
      raise "Unexpected timeline type(#{@timeline_type}) given."
    end
  end
end
