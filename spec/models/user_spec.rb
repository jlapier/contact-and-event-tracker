require 'spec_helper'

describe User do
  before(:each) do
    @valid_attributes = {
      :email => "Joe@example.com", :password => "secret", :password_confirmation => "secret"
    }
  end

  it "should create a new instance given valid attributes" do
    User.create!(@valid_attributes)
  end

  it "should create a contact for each user" do
    user = User.create(@valid_attributes)
    user.contact.should_not be_nil
  end
  
  it "should know its name or its contact name or say unknown" do
    user = User.create(@valid_attributes)
    user.name_or_contact_name.should == 'unknown'
    
    user.contact = mock_model(Contact, {
      :first_name => 'Joe',
      :last_name => 'Blow',
      :name => 'Blow, Joe'
    })
    user.name_or_contact_name.should == 'Joe Blow'
    user.name = 'Joey Doe'
    user.name_or_contact_name.should == 'Joey Doe'
  end
end
