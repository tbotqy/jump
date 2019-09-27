# frozen_string_literal: true

class GenerateSitemapJob < ApplicationJob
  queue_as :default

  def perform(*args)
    SitemapGenerator::Sitemap.create(options) do
      add "/terms_and_privacy", changefreq: "never"

      public_tweeted_dates = Status.not_private.distinct(:tweeted_on).order(tweeted_on: :desc).pluck(:tweeted_on)
      format = "/%Y/%-1m/%-1d"
      date_params = public_tweeted_dates.map { |date| date.strftime(format) }
      date_params.each do |date_param|
        add "/public_timeline#{date_param}"
      end
    end
  end

  private
    def options
      {
        default_host: Settings.frontend_url,
        public_path:  Settings.sitemap_dir,
        verbose:      false,
        compress:     false
      }
    end
end
