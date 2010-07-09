require 'spec_helper'

describe "/events/index.html.erb" do
  include EventsHelper

  before(:each) do
    template.stub(:has_authorization?).and_return(true)
    assigns[:events] = [
      stub_model(Event,
        :name => "value for name",
        :event_type => "value for event_type",
        :location => "value for location",
        :description => "value for description"
      ),
      stub_model(Event,
        :name => "value for name",
        :event_type => "value for event_type",
        :location => "value for location",
        :description => "value for description"
      )
    ]
  end

  it "renders a list of events" do
    render
  end
end
