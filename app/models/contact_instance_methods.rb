module ContactInstanceMethods
  def name
    "#{last_name}, #{first_name}"
  end

  def fullname
    name
  end

  def agency_and_division(separator = "; ")
    if agency.blank?
      division
    elsif division.blank?
      agency
    else
      "#{agency}#{separator}#{division}"
    end
  end
end