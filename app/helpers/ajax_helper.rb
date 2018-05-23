module AjaxHelper
  def term_selector_class_name(index, max)
    return 'first last' if max == 1
    case index
    when 1
      'first'
    when max
      'last'
    else
      'mid'
    end
  end
end
