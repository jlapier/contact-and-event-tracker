class EventRevision < ActiveRecord::Base
  
  acts_as_revision :revisable_class_name => 'Event'
  
  #has_many :attendees, :class_name => "AttendeeRevision"
  
end