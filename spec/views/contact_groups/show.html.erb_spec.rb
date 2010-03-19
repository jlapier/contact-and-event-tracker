require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/contact_groups/show.html.erb" do
  include ContactGroupsHelper
  before(:each) do
    assigns[:contact_group] = @contact_group = stub_model(ContactGroup,
      :contacts => [stub_model(Contact, :name => 'Joe Blow', :email => 'joeblow@a.c')])
  end

  it "renders attributes in <p>" do
    render
  end
end
