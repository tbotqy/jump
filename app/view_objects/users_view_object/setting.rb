module UsersViewObject
  class Setting
    delegate :name,        to: :user, prefix: :user
    delegate :screen_name, to: :user, prefix: :user

    def initialize(user)
      @user = user
    end

    def profile_image_url
      user.profile_image_url_https.gsub(/_normal/,'_reasonably_small')
    end

    def total_status_count
      user.statuses.count.to_s(:delimited)
    end

    def friends_count
      user.friends.count.to_s(:delimited)
    end

    def profile_updated_at
      Time.zone.at(user.updated_at).strftime('%F %T')
    end

    def friends_updated_at
      friends_updated_at = user.friends_updated_at
      return "---" if friends_updated_at.blank?
      Time.zone.at(friends_updated_at).strftime('%F %T')
    end

    def statuses_updated_at
      Time.zone.at(user.statuses_updated_at).strftime('%F %T')
    end

    private

    attr_reader :user # for delegate
  end
end
