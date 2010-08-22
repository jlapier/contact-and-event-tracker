class ContactRevision < ActiveRecord::Base
  belongs_to :modified_by_user, :class_name => 'User'
  
  acts_as_revision :revisable_class_name => 'Contact'

end
