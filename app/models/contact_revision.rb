class ContactRevision < ActiveRecord::Base
  
  acts_as_revision :revisable_class_name => 'Contact'
  
end