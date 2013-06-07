module ApplicationHelper

  def title(given_title = nil)
    base_title = configatron.site_name
    if given_title.nil?
      base_title
    else
      base_title + " - "+given_title
    end
  end
  
end
