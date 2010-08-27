require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/contact_groups/show.html.erb" do
  include ContactGroupsHelper
  before(:each) do
    template.stub(:load_and_authorize_current_user?).and_return(true)
    template.stub(:has_authorization?).and_return(true)
    template.stub(:logged_in?).and_return(true)
    assigns[:contact_group] = @contact_group = stub_model(ContactGroup,
      :events_attended_by_members => [],
      :contacts => [stub_model(Contact, :name => 'Joe Blow', :email => 'joeblow@a.c')])
  end

  it "renders attributes in <p>" do
    render
  end
end
