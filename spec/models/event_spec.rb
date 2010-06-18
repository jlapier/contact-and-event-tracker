require 'spec_helper'

describe Event do
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

  it "should create a new instance given valid attributes" do
    Event.create!(@valid_attributes)
  end

  it "should find event types" do
    Event.create!(@valid_attributes)
    Event.create!(@valid_attributes.merge :event_type => 'Conference')
    Event.existing_event_types.should == ['Conference', 'Meeting']
  end
  
  it "should call to_hash_for_calendar" do
    event = Event.create! :name => "test", :start_on => "2010-01-01", :end_on => "2010-01-07", 
      :event_type => "meeting", :description => "some kind of meeting", :location => 'skype.address'
    event.to_hash_for_calendar.should == { :id => event.id, :title => "test", 
      :start => Date.new(2010,1,1), :end => Date.new(2010,1,7), :url => "/events/#{event.id}",
      :description => "some kind of meeting", :location => 'skype.address' }
  end
end
