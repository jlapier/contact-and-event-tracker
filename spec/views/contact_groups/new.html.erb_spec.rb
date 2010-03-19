require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/contact_groups/new.html.erb" do
  include ContactGroupsHelper

  before(:each) do
    assigns[:contact_group] = stub_model(ContactGroup,
      :new_record? => true
    )
  end

  it "renders new contact_group form" do
    render

    response.should have_tag("form[action=?][method=post]", contact_groups_path) do
    end
  end
end
