require 'spec_helper'

describe ContactGroup do
  before(:each) do
    @valid_attributes = {
      :name => "value for name"
    }
    @contact = Contact.create! :first_name => "joe"
  end

  it "should create a new instance given valid attributes" do
    ContactGroup.create!(@valid_attributes)
  end

  it "should get some contacts" do
    cg = ContactGroup.create(@valid_attributes)

    cg.contacts.should be_empty
    cg.contacts << @contact
    cg.reload
    cg.contacts.should_not be_empty
    @contact.reload
    @contact.contact_groups.should == [cg]
  end

end
