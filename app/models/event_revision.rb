class EventRevision < ActiveRecord::Base
  
  acts_as_revision :revisable_class_name => 'Event'
  
  def attendees
    attendee_roster.blank? ? [] : Attendee.find(attendee_roster.split(','))
  end
  
end