class EventRevision < ActiveRecord::Base
  belongs_to :modified_by_user, :class_name => 'User'
  
  acts_as_revision :revisable_class_name => 'Event'
  
  def attendees
    attendee_roster.blank? ? [] : Contact.find(attendee_roster.split(','))
  end
  
end