module ApplicationHelper

  def title
    base_title = configatron.site_name.to_s.concat(" -")
    if @title.nil?
      base_title
    else
      base_title.concat(@title)
    end
  end

end
