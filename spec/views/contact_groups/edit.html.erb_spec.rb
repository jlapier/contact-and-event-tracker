require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/contact_groups/edit.html.erb" do
  include ContactGroupsHelper

  before(:each) do
    assigns[:contact_group] = @contact_group = stub_model(ContactGroup,
      :new_record? => false
    )
  end

  it "renders the edit contact_group form" do
    render

    response.should have_tag("form[action=#{contact_group_path(@contact_group)}][method=post]") do
    end
  end
end
