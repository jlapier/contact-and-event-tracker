module ContactClassMethods
  def existing_states
    find(:all, :select => 'DISTINCT state').map(&:state).reject { |st| st.blank? }.sort
  end

  def existing_agencies
    find(:all, :select => 'DISTINCT agency').map(&:agency).reject { |ag| ag.blank? }.sort
  end

  def existing_divisions
    find(:all, :select => 'DISTINCT division').map(&:division).reject { |di| di.blank? }.sort
  end

  def string_attributes
    [:first_name, :last_name, :title, :division, :agency, :city, :state, :zip,
      :agency_phone, :direct_phone, :alternate_phone, :fax_phone]
  end

  def link_attributes
    [:email, :website]
  end

  def text_attributes
    [:street_address, :comments, :descriptors, :home_address]
  end

  def datetime_attributes
    [:created_at, :updated_at]
  end
end