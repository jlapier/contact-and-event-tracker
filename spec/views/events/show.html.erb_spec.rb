require 'spec_helper'

describe "/events/show.html.erb" do
  include EventsHelper
  before(:each) do
    template.stub(:is_admin?).and_return true
    template.stub(:logged_in?).and_return true
    assigns[:event] = @event = stub_model(Event,
      :name => "value for name",
      :event_type => "value for event_type",
      :location => "value for location",
      :description => "value for description",
      :contacts => [stub_model(Contact, :name => 'Joe Blow', :email => 'joeblow@a.c')],
      :contact_groups_represented => [stub_model(ContactGroup, :name => 'Test Group')],
      :updated_at => Time.now
    )
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(/value\ for\ name/)
    response.should have_text(/value\ for\ event_type/)
    response.should have_text(/value\ for\ location/)
    response.should have_text(/value\ for\ description/)
  end
end
