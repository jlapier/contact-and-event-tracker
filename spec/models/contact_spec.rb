require 'spec_helper'

describe Contact do
  before(:each) do
    @valid_attributes = {
      :first_name => "Joe", :last_name => "Camel"
    }
  end

  it "should create a new instance given valid attributes" do
    Contact.create!(@valid_attributes)
  end
  
  it "should create a new version when an attribute is updated" do
    contact = Contact.create!(@valid_attributes)
    contact.first_name = 'Sally'
    contact.revision_number.should == 0
    contact.save
    contact.revision_number.should == 1
  end
  
  it "belongs to a user who has modified it" do
    contact = Contact.new
    contact.should respond_to(:modified_by_user)
    contact.should respond_to(:build_modified_by_user)
  end
end
