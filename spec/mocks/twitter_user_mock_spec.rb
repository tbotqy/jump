# frozen_string_literal: true

require "rails_helper"

describe TwitterUserMock do
  include TwitterUserMock

  describe "twitter_user_mock" do
    subject { twitter_user_mock(params) }

    let(:default_attrs) do
      {
        name:                    "name",
        screen_name:             "screen_name",
        protected?:              false,
        profile_image_url_https: Addressable::URI.parse("https://example.com/foo.jpg"),
        profile_banner_url_https: Addressable::URI.parse("https://example.com/bar")
      }
    end

    shared_examples "#profile_image_url_https is an Addressable::URI" do
      it { expect(subject.profile_image_url_https).to be_an(Addressable::URI) }
    end
    shared_examples "#profile_banner_url_https is an Addressable::URI" do
      it { expect(subject.profile_banner_url_https).to be_an(Addressable::URI) }
    end

    describe "default state" do
      let(:params) { {} }
      it "it has default values" do
        is_expected.to have_attributes(default_attrs)
      end
      it_behaves_like "#profile_image_url_https is an Addressable::URI"
      it_behaves_like "#profile_banner_url_https is an Addressable::URI"
    end

    describe "ability to overwrite attributes" do
      context "to partially overwrite" do
        describe "#name" do
          let(:params) { { name: "new name" } }
          it "only overwrites name" do
            is_expected.to have_attributes(default_attrs.merge(name: "new name"))
          end
        end
        describe "#screen_name" do
          let(:params) { { screen_name: "new screen_name" } }
          it "only overwrites screen_name" do
            is_expected.to have_attributes(default_attrs.merge(screen_name: params.fetch(:screen_name)))
          end
        end
        describe "#protected?" do
          let(:params) { { protected?: true } }
          it "only overwrites protected" do
            is_expected.to have_attributes(default_attrs.merge(protected?: params.fetch(:protected?)))
          end
        end
        describe "#profile_image_url_https" do
          shared_examples "only overwrites profile_image_url_https, regardless of the type of given value" do
            it do
              is_expected.to have_attributes(
                default_attrs.merge(profile_image_url_https: Addressable::URI.parse(params.fetch(:profile_image_url_https)))
              )
            end
          end
          context "given as a string" do
            let(:params) { { profile_image_url_https: "https://example.com/new.jpg" } }
            it_behaves_like "only overwrites profile_image_url_https, regardless of the type of given value"
            it_behaves_like "#profile_image_url_https is an Addressable::URI"
          end
          context "given as an Addressable::URI" do
            let(:params) { { profile_image_url_https: Addressable::URI.parse("https://example.com/new.jpg") } }
            it_behaves_like "only overwrites profile_image_url_https, regardless of the type of given value"
            it_behaves_like "#profile_image_url_https is an Addressable::URI"
          end
        end
        describe "#profile_banner_url_https" do
          shared_examples "only overwrites profile_banner_url_https, regardless of the type of given value" do
            it do
              is_expected.to have_attributes(
                default_attrs.merge(profile_banner_url_https: Addressable::URI.parse(params.fetch(:profile_banner_url_https)))
              )
            end
          end
          context "given as a string" do
            let(:params) { { profile_banner_url_https: "https://example.com/new.jpg" } }
            it_behaves_like "only overwrites profile_banner_url_https, regardless of the type of given value"
            it_behaves_like "#profile_banner_url_https is an Addressable::URI"
          end
          context "given as an Addressable::URI" do
            let(:params) { { profile_banner_url_https: Addressable::URI.parse("https://example.com/new.jpg") } }
            it_behaves_like "only overwrites profile_banner_url_https, regardless of the type of given value"
            it_behaves_like "#profile_banner_url_https is an Addressable::URI"
          end
        end
      end

      context "to completely overwrite" do
        let(:params) do
          {
            name:                    "new name",
            screen_name:             "new screen_name",
            protected?:              true,
            profile_image_url_https: Addressable::URI.parse("https://example.com/new.jpg"),
            profile_banner_url_https: Addressable::URI.parse("https://example.com/new")
          }
        end
        it "overwrite all the attrs" do
          is_expected.to have_attributes(
            name:                    params.fetch(:name),
            screen_name:             params.fetch(:screen_name),
            protected?:              params.fetch(:protected?),
            profile_image_url_https: params.fetch(:profile_image_url_https),
            profile_banner_url_https: params.fetch(:profile_banner_url_https)
          )
        end
        it_behaves_like "#profile_image_url_https is an Addressable::URI"
        it_behaves_like "#profile_banner_url_https is an Addressable::URI"
      end
    end
  end
end
