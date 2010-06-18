require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/contact_groups/index.html.erb" do
  include ContactGroupsHelper

  before(:each) do
    template.stub(:is_admin?).and_return true
    assigns[:contact_groups] = [
      stub_model(ContactGroup),
      stub_model(ContactGroup)
    ]
  end

  it "renders a list of contact_groups" do
    render
  end
end
