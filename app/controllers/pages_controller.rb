class PagesController < ApplicationController
  def for_users
    @show_header = false
    @show_to_page_top = false
  end

  def browsers
    @show_footer = true
  end
end
