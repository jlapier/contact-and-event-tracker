# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

require 'csv'

CSV.open('db/pac-emails.csv', 'r') do |row|
  Contact.create :first_name => row[1], :last_name => row[2], :email => row[3]
end

