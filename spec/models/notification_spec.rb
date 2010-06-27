require 'spec_helper'

describe Notification do
  
  before(:each) do
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
  end
  
  describe "password reset confirmation" do
    
    before(:each) do
      @user = mock_model(User, {:email => 'tester@test.com', :perishable_token => 'UsersPerishableToken'})
      @response = Notification.create_password_reset_confirmation(@user)
    end
    
    it "should have a subject: Confirm password reset request" do
      @response.subject.should_not be_nil
      @response.subject.should == "Confirm password reset request"
    end
    
    it "should be from: test@test.com" do
      @response.from.should_not be_nil
      @response.from.should == ['test@example.com']
    end
    
    it "should have a recipient: tester@test.com" do
      @response.to.should == [@user.email]
    end
    
    it "should include the user perishable token in a link within the body of the message" do
      @response.body.include?('/password_resets/UsersPerishableToken').should be_true
    end    
    
  end
  
end