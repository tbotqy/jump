# frozen_string_literal: true

namespace :migrate_entities_to_others do
  desc "migrate entities to hashtags, urls, and media table"

  def create_progress_bar
    total = Entity.where(entity_type: %i|hashtags urls media|).count
    ProgressBar.create(total: total, format: "%t: |%B| %a %E  %c/%C %P%%")
  end

  task start: :environment do
    progress_bar = create_progress_bar

    ApplicationRecord.transaction do
      progress_bar.title = "Migrating hashtags"
      Entity.where(entity_type: :hashtags).find_in_batches do |entity_hashtags|
        hashtags = entity_hashtags.map do |entity_hashtag|
          Hashtag.new(
            status_id: entity_hashtag.status_id,
            hashtag:   entity_hashtag.hashtag,
            index_f:   entity_hashtag.indice_f,
            index_l:   entity_hashtag.indice_l
          )
        end
        Hashtag.import! hashtags
        hashtags.each { progress_bar.increment }
      end

      progress_bar.title = "Migrating urls"
      Entity.where(entity_type: :urls).find_in_batches do |entity_urls|
        urls = entity_urls.map do |entity_url|
          Url.new(
            status_id:   entity_url.status_id,
            url:         entity_url.url,
            display_url: entity_url.display_url,
            index_f:     entity_url.indice_f,
            index_l:     entity_url.indice_l
          )
        end
        Url.import! urls
        urls.each { progress_bar.increment }
      end

      progress_bar.title = "Migrating media"
      Entity.where(entity_type: :media).find_in_batches do |entity_media|
        media = entity_media.map do |entity_medium|
          Medium.new(
            status_id:   entity_medium.status_id,
            url:         entity_medium.url,
            direct_url:  nil,
            display_url: entity_medium.display_url,
            index_f:     entity_medium.indice_f,
            index_l:     entity_medium.indice_l
          )
        end
        Medium.import! media
        media.each { progress_bar.increment }
      end

      progress_bar.title = "Done"
    end
  end
end
