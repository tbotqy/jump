module ParamUtil
  
  def detect_date_type(date_in_param)
    case date_in_param.count("-")
    when 1
      "year"
    when 2
      "month"
    when 3
      "day"
    end
  end

  def calc_term_of_date(date_in_param)

end
