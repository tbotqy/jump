class Entity < ActiveRecord::Base
  belongs_to :status
  class << self
    def bulk_new_by_tweet(tweet)
      ret = []
      return ret unless tweet.entities?

      # save all the types of entities belonging to tweet
      ret << bulk_new_by_type(:hashtags,      tweet.hashtags)
      ret << bulk_new_by_type(:urls,          tweet.urls)
      ret << bulk_new_by_type(:media,         tweet.media)
      ret << bulk_new_by_type(:user_mentions, tweet.user_mentions)
      ret.flatten
    end

    private

    def bulk_new_by_type(type, entities)
      entities.map do |entity|
        ret = new(created_at: Time.zone.now.to_i)
        ret.assign_by_type(type, entity)
        ret
      end
    end
  end

  def assign_by_type(type, entity)
    case type
    when :hashtags
      assign_hashtag(entity)
    when :urls
      assign_url(entity)
    when :media
      assign_media(entity)
    when :user_mentions
      assign_user_mention(entity)
    else
      raise "Unexpected entity type.(#{type})"
    end
  end

  def assign_hashtag(hashtag)
    self.hashtag     = hashtag.text
    self.indice_f    = hashtag.indices.first
    self.indice_l    = hashtag.indices.last
    self.entity_type = :hashtags
  end

  def assign_url(url)
    self.url         = url.url.to_s
    self.display_url = url.display_url
    self.indice_f    = url.indices.first
    self.indice_l    = url.indices.last
    self.entity_type = :urls
  end

  def assign_media(media)
    self.url         = media.url.to_s
    self.display_url = media.display_url
    self.indice_f    = media.indices.first
    self.indice_l    = media.indices.last
    self.entity_type = :media
  end

  def assign_user_mention(user_mention)
    self.mention_to_screen_name = user_mention.screen_name,
    self.mention_to_user_id_str = user_mention.attrs[:id_str] # TODO : try to abandon
    self.indice_f               = user_mention.indices.first
    self.indice_l               = user_mention.indices.last
    self.entity_type            = :user_mentions
  end
end
