class Event < ActiveRecord::Base
  has_and_belongs_to_many :contacts, :order => ["last_name, first_name"]

  validates_presence_of :name, :event_type, :start_on
  
  def validate
    if start_on and end_on and start_on > end_on
      errors.add :end_on, "cannot be before the start date"
    end
  end

  class << self
    def existing_event_types
      find(:all, :select => 'DISTINCT event_type').map(&:event_type).reject { |ev| ev.blank? }.sort
    end
  end

  def drop_contacts(drop_contact_ids)
    drop_contact_ids = [*drop_contact_ids].compact.map(&:to_i)
    self.contact_ids = contact_ids - drop_contact_ids
    self.save
  end


  def to_s
    "#{name} (#{start_on} #{end_on ? ' - ' + end_on.to_s : ''})"
  end
  
  def to_hash_for_calendar
    { :id => id, :title => name, :start => start_on, :end => end_on, :url => "/events/#{id}" }
  end

  # list all groups that had least one member in attendance at this event
  def contact_groups_represented
    @contact_groups_represented ||= contacts.map(&:contact_groups).flatten.uniq
  end
end
