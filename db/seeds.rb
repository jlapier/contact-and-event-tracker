# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

require 'csv'

contacts = []

CSV.open('/home/jason/rails/pac_rti/contact-and-event-tracker/db/pac-emails-new.csv', 'r') do |row|
  #Contact.create :first_name => row[1], :last_name => row[2], :email => row[3]
  #contacts << Contact.find( :first, :conditions => { :first_name => row[1], :last_name => row[2] }  )
  contact = Contact.find( :first, :conditions => { :first_name => row[0], :last_name => row[1] }  )
  contact.update_attributes :title => row[2], :division => row[3], :agency => row[4], :city => row[5],
    :state => row[6], :zip => row[7], :agency_phone => row[8], :direct_phone => row[9],
    :alternate_phone => row[10], :fax_phone => row[11], :website => row[12], :street_address => row[13],
    :comments => row[14], :descriptors => row[15], :home_address => row[16]
end

