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
  
  it "should create a new version when an attribute is updated" do
    event = Event.create!(@valid_attributes)
    event.revision_number.should == 0
    event.name = "updated test"
    event.save
    event.revision_number.should == 1
  end
  
  context "with attendees" do
    
    before(:each) do
      @event = Event.create!(@valid_attributes)
      @event.attendees << Attendee.new(:contact => Contact.create!(:first_name => 'John', :last_name => 'Doe'))
      @event.save
    end

    context "adding an attendee" do
      
      it "should update attendee_roster" do
        @event.attendee_roster.should == @event.attendee_ids.join(',')
      end

      it "should create a new version" do
        @event.revision_number.should == 1
      end

      it "should have previous set of attendees available through the previous revision" do
        @event.find_revision(:previous).attendees.count.should == 0
        @event.attendees << Attendee.new(:contact => Contact.create!(:first_name => 'Jane', :last_name => 'Reeses'))
        @event.save
        @event.find_revision(:previous).attendees.count.should == 1
        @event.attendees.count.should == 2
      end
    end

    context "removing an attendee" do

      before(:each) do
        @attendee = @event.attendees.first
        @event.attendees.delete(@attendee)
        @event.save
      end
      
      it "should not include the removed attendee in the collection" do
        @event.attendees.count.should == 0
      end
      
      it "should create a new version" do
        @event.revision_number.should == 2
      end
      
      it "should have previous set of attendees available through the previous revision" do
        @event.find_revision(:previous).attendees.first.should == @attendee
      end

    end
  end
  
end
