class Contact < ActiveRecord::Base
  
  has_one :user
  has_and_belongs_to_many :contact_groups, :order => 'name'
  has_many :registrations, :class_name => 'Attendee', :conditions => {:revisable_is_current => true}
  has_many :events, :through => :registrations, :order => ["start_on"], :conditions => {:revisable_is_current => true}
  belongs_to :modified_by_user, :class_name => 'User'

  searchable_by :first_name, :last_name, :agency, :division, :state, :email
  
  acts_as_revisable :revision_class_name => 'ContactRevision', :on_destroy => :revise
  
  acts_as_stripped :first_name, :last_name, :title, :division, :agency, :city, :state, :zip,
    :agency_phone, :direct_phone, :alternate_phone, :fax_phone, :email, :street_address,
    :comments, :descriptors, :home_address, :created_at, :updated_at
  
  extend ContactClassMethods
  include ContactInstanceMethods
end
