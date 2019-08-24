# frozen_string_literal: true

module UrlEntityPresentable
  def as_json(options = {})
    {
      url:         url,
      display_url: display_url,
      indices: [
        index_f,
        index_l
      ]
    }
  end
end
