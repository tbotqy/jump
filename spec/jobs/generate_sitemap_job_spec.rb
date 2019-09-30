# frozen_string_literal: true

require "rails_helper"

RSpec.describe GenerateSitemapJob, type: :job do
  subject { -> { described_class.perform_now } } # define as a Proc to prevent it from being memorized

  let(:sitemap_xml_path) { "#{Settings.sitemap_dir}/sitemap.xml" }
  after { File.delete(sitemap_xml_path) }

  let(:date_path_format) { "/%Y/%-1m/%-1d" }

  context "A sitemap is not yet generated" do
    it "generates sitemap.xml" do
      is_expected.to change { File.exist?(sitemap_xml_path) }.from(false).to(true)
    end

    describe "All the expected paths are included in the sitemap" do
      it "includes the root url" do
        subject.call
        expect(File.read(sitemap_xml_path)).to include("<loc>#{Settings.frontend_url}</loc>")
      end

      it "includes the url for terms and privacy" do
        subject.call
        expect(File.read(sitemap_xml_path)).to include("<loc>#{Settings.frontend_url}/terms_and_privacy</loc>")
      end

      describe "includes all the urls of public_timeline" do
        let(:public_tweeted_dates)  { [1, 2].map { |day| Time.local(2019, 1, day) } }
        let(:private_tweeted_dates) { [3, 4].map { |day| Time.local(2019, 1, day) } }
        before do
          public_tweeted_dates.each  { |public_tweeted_date|  create(:status, private_flag: false, tweeted_at: public_tweeted_date.to_i) }
          private_tweeted_dates.each { |private_tweeted_date| create(:status, private_flag: true,  tweeted_at: private_tweeted_date.to_i) }
        end

        it "includes the paths of the tweeted day of public statuses" do
          subject.call
          public_tweeted_dates.each do |public_tweeted_date|
            expect(File.read(sitemap_xml_path)).to include("<loc>#{Settings.frontend_url}/public_timeline#{public_tweeted_date.strftime(date_path_format)}</loc>")
          end
        end
        it "doesn't include the paths of the tweeted day of private statuses" do
          subject.call
          private_tweeted_dates.each do |private_tweeted_date|
            expect(File.read(sitemap_xml_path)).not_to include("<loc>#{Settings.frontend_url}/public_timeline#{private_tweeted_date.strftime(date_path_format)}</loc>")
          end
        end
      end
    end
  end

  context "A sitemap is already generated" do
    let(:existing_tweeted_date)   { Time.local(2019, 1, 1) }
    let(:additional_tweeted_date) { Time.local(2019, 1, 2) }
    let(:additional_path) { additional_tweeted_date.strftime(date_path_format) }
    before do
      create(:status, tweeted_at: existing_tweeted_date.to_i)
      subject.call
      create(:status, tweeted_at: additional_tweeted_date.to_i)
    end
    it "updates the existing sitemap" do
      is_expected.to change { File.read(sitemap_xml_path).include?(additional_path) }.from(false).to(true)
    end
  end
end
