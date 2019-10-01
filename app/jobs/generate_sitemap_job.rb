# frozen_string_literal: true

class GenerateSitemapJob < ApplicationJob
  queue_as :default

  def perform(*args)
    SitemapGenerator::Sitemap.create(options) do
      add Settings.frontend.terms_and_privacy_path, changefreq: "never"

      # add urls of public user timeline
      User.not_protected.find_in_batches do |users|
        users.pluck(:screen_name).each { |screen_name| add "#{Settings.frontend.user_page_path}/#{screen_name}" }
      end

      # add urls of public_timeline
      public_tweeted_dates = Status.not_protected.distinct(:tweeted_on).order(tweeted_on: :desc).pluck(:tweeted_on)
      format = "/%Y/%-1m/%-1d"
      date_params = public_tweeted_dates.map { |date| date.strftime(format) }
      date_params.each do |date_param|
        add "#{Settings.frontend.public_timeline_path}#{date_param}"
      end
    end
  end

  private
    def options
      {
        default_host: Settings.frontend.url,
        public_path:  Settings.sitemap_dir,
        verbose:      false,
        compress:     false
      }
    end
end
