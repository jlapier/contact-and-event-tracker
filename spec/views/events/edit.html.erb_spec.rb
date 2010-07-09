require 'spec_helper'

describe "/events/edit.html.erb" do
  include EventsHelper

  before(:each) do
    template.stub(:has_authorization?).and_return(true)
    assigns[:event] = @event = stub_model(Event,
      :new_record? => false,
      :name => "value for name",
      :event_type => "value for event_type",
      :location => "value for location",
      :description => "value for description"
    )
  end

  it "renders the edit event form" do
    render

    response.should have_tag("form[action=#{event_path(@event)}][method=post]") do
      with_tag('input#event_name[name=?]', "event[name]")
      with_tag('input#event_event_type[name=?]', "event[event_type]")
      with_tag('textarea#event_location[name=?]', "event[location]")
      with_tag('textarea#event_description[name=?]', "event[description]")
    end
  end
end
