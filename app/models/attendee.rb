class Attendee < ActiveRecord::Base  
  belongs_to :contact
  belongs_to :event
  
  acts_as_revisable :revision_class_name => 'AttendeeRevision'
end