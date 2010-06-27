require 'spec_helper'

describe PasswordReset do
  
  context "without an assigned user" do
    
    before(:each) do
      User.stub(:count).and_return(0)
    end
    
    describe "before validation when created" do
      
      it "should have as status of 'invalid email'" do
        password_reset = PasswordReset.create({
          :sent_to => 'nevershouldexistinanyfixtures'
        })
        password_reset.status.should == 'invalid email'
      end
      
    end
    
  end
  
  context "with an assigned user" do
    
    before(:each) do
      @user = mock_model(User, {
        :id => 12,
        :perishable_token => 'UsersPerishableToken',
        :confirm_password_reset => nil
      })
      User.stub(:find_by_email).and_return(@user)
      User.stub(:count).and_return(1)
    end
    
    describe "before validation when created" do
      
      it "loads and associates with a user by email" do
        User.should_receive(:find_by_email).with('test@example.com').and_return(@user)
        password_reset = PasswordReset.create({
          :sent_to => 'test@example.com'
        })
        password_reset.user.should == @user
      end
      
      it "sets an initial status" do
        password_reset = PasswordReset.new({
          :sent_to => 'test@example.com'
        })
        password_reset.stub(:send_confirmation_email)
        password_reset.save.should be_true
        password_reset.status.should == 'pending'
      end
    end
    
    describe "after creation" do
      it "should tell user to confirm their request" do
        @user.should_receive(:confirm_password_reset)
        User.stub(:find_by_email).and_return(@user)
        PasswordReset.create({
          :sent_to => 'test@example.com'
        })
      end

       it "should update its status to 'email sent'" do
         password_reset = PasswordReset.create({
           :sent_to => 'test@example.com'
         })
         password_reset.status.should == 'email sent'
       end

       it "should be saved" do
         password_reset = PasswordReset.create({
           :sent_to => 'test@example.com'
         })
         password_reset.status.should == 'email sent'
       end
    end
    
  end
  
  it "can be confirmed" do
    password_reset = PasswordReset.create({
      :sent_to => 'jeremiah@inertialbit.net'
    })
    password_reset.confirm('0.0.0.0')
    password_reset.reload
    password_reset.status.should == 'confirmed'
    password_reset.confirming_ip.should == '0.0.0.0'
  end

end
