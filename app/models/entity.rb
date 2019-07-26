# frozen_string_literal: true

class Entity < ApplicationRecord
  # deprecated

  belongs_to :status

  def as_json(_options = {})
    {
      url: url,
      display_url: display_url,
      indice_f: indice_f,
      indice_l: indice_l
    }
  end
end
