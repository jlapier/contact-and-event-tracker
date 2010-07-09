require 'spec_helper'

describe "/events/new.html.erb" do
  include EventsHelper

  before(:each) do
    template.stub(:has_authorization?).and_return(true)
    assigns[:event] = stub_model(Event,
      :new_record? => true,
      :name => "value for name",
      :event_type => "value for event_type",
      :location => "value for location",
      :description => "value for description"
    )
  end

  it "renders new event form" do
    render

    response.should have_tag("form[action=?][method=post]", events_path) do
      with_tag("input#event_name[name=?]", "event[name]")
      with_tag("input#event_event_type[name=?]", "event[event_type]")
      with_tag("textarea#event_location[name=?]", "event[location]")
      with_tag("textarea#event_description[name=?]", "event[description]")
    end
  end
end
