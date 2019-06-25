# frozen_string_literal: true

require "rails_helper"

RSpec.describe Entity, type: :model do
  describe "#as_json" do
    subject { entity.as_json }

    let(:url)         { "https://example.com" }
    let(:display_url) { "https://t.co/foobar" }
    let(:indice_f)    { 1 }
    let(:indice_l)    { 3 }
    let!(:entity)     { create(:entity, url: url, display_url: display_url, indice_f: indice_f, indice_l: indice_l) }

    it do
      is_expected.to include(
        url: url,
        display_url: display_url,
        indice_f: indice_f,
        indice_l: indice_l
      )
    end
  end
end
