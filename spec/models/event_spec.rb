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
end
