require 'spec_helper'

describe EventRevision do
  
  before(:each) do
    @valid_attributes = {
      :name => "value for name",
      :event_type => "Meeting",
      :start_on => Date.today,
      :end_on => Date.today,
      :location => "value for location",
      :description => "value for description"
    }
  end
  
  it "should have an attendee collection" do
    event = Event.create!(@valid_attributes)
    event.name = 'other value'
    event.save
    EventRevision.first.attendees.count.should == 0
    event.attendees << Attendee.new(:contact => Contact.create!(:first_name => 'Jane', :last_name => 'Doe'))
    event.save
    event.attendees << Attendee.new(:contact => Contact.create!(:first_name => 'Jon', :last_name => 'Mill'))
    event.save
    event.find_revision(:previous).attendees.count.should == 1
    event.attendees.count.should == 2
  end
  
end