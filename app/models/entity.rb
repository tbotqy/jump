class Entity < ActiveRecord::Base
  belongs_to :status

  def self.save_entities(status_id,status)

    # save given entities with its status_id linked

    entities = status[:attrs][:entities]

    # save entities
    entities.each do |entity_type,entity_bodies|
      # check if 'type' has its node (hashtags,urls, and so on)
      if entity_bodies.size > 0
        entity_bodies.each do |entity_body|
          Entity.create( self.create_hash_to_save(status_id,status,entity_body,entity_type) )
        end
      end
    end
  end

  def self.create_hash_to_save(status_id,status,entity_body,entity_type)

    ret = {
      :status_id => status_id,
      :status_id_str => status[:attrs][:id_str],
      :indice_f => entity_body[:indices][0],
      :indice_l => entity_body[:indices][1],
      :entity_type => entity_type,
      :created_at => Time.zone.now.to_i
    }

    case entity_type.to_s

    when 'hashtags'
      ret[:hashtag] = entity_body[:text]
    when 'urls'
      ret[:url] = entity_body[:url]
      ret[:display_url] = entity_body[:display_url]
    when 'media'
      ret[:url] = entity_body[:url]
      ret[:display_url] = entity_body[:display_url]
    when 'user_mentions'
      ret[:mention_to_screen_name] = entity_body[:screen_name]
      ret[:mention_to_user_id_str] = entity_body[:id_str]
    end

    ret
  end

end
