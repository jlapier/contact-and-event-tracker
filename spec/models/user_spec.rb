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
end
