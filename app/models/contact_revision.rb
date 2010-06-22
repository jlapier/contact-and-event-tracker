class ContactRevision < ActiveRecord::Base
  
  acts_as_revision :revisable_class_name => 'Contact'
  
  has_many :registrations, :class_name => 'AttendeeRevision'
  has_many :events, :through => :registrations, :order => ["start_on"], :class_name => 'EventRevision'
  
end