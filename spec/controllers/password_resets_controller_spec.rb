require 'spec_helper'

def should_restart(msg='Please submit your email to reset your password.', &block)
  yield
  flash[:notice].should == msg
  response.should redirect_to new_password_reset_path
end

def should_load_user(&block)
  user = mock_model(User, {
    :perishable_token => 'UsersPerishableToken',
    :password_reset_confirmed => nil
  })
  User.should_receive(:find_using_perishable_token).with(
    'UsersPerishableToken', 24.hours
  ).and_return(user)
  yield
  assigns[:user].should == user
end

def sets_flash(type, &block)
  yield
  flash[type].should_not be_nil
end

describe PasswordResetsController do
  
  before(:each) do
    controller.stub(:require_no_user)
  end

  context "GET" do

    describe ":index" do
      it "should redirect to the new password reset" do
        should_restart{ get :index }
      end
    end

    describe ":new" do
      it "should instantiate a new PasswordReset as @password_reset" do
        @password_reset = mock_model(PasswordReset).as_new_record
        PasswordReset.should_receive(:new).and_return(@password_reset)
        get :new
        assigns[:password_reset].should == @password_reset
      end
      
      it "renders the new template" do
        get :new
        response.should render_template('password_resets/new')
      end
    end
    
    describe ":show, :id => UsersPerishableToken" do
      before(:each) do
        @user = mock_model(User, {
          :perishable_token => 'UsersPerishableToken',
          :password_reset_confirmed => nil
        })
        User.stub(:find_using_perishable_token).and_return(@user)
      end
      
      it "should load the user with the perishable token" do
        should_load_user{ get :show, :id => 'UsersPerishableToken' }
      end
      
      it "should redirect to the new password reset page if no user loads" do
        User.stub(:find_using_perishable_token).and_return(nil)
        get :show, :id => 'users_perishable_token'
        response.should redirect_to(new_password_reset_path)
      end
      
      it "should confirm the password reset" do
        @user.should_receive(:password_reset_confirmed).with(
        '0.0.0.0'
        )
        get :show, :id => 'UsersPerishableToken'
      end
      context "confirmation succeeds :)" do
        before(:each) do
          @user.stub(:password_reset_confirmed).and_return(true)
        end
        
        it "sets a flash[:notice]" do
          sets_flash(:notice){ get :show, :id => 'UsersPerishableToken' }
        end
        
        it "renders the edit template" do
          get :show, :id => 'UsersPerishableToken'
          response.should render_template('password_resets/edit')
        end
      end
      
      context "confirmation fails :(" do
        before(:each) do
          @user.stub(:password_reset_confirmed).and_return(false)
        end
        
        it "sets a flash[:notice]" do
          sets_flash(:notice){ get :show, :id => 'UsersPerishableToken' }
        end
        
        it "restart the password reset request" do
          should_restart('There was an error with your request. Please try again.'){ get :show, :id => 'UsersPerishableToken' }
        end
      end
      
    end
    
  end
  
  context "POST" do
    
    describe ":create, :password_reset => {}" do
      before(:each) do
        @password_reset = mock_model(PasswordReset, {
          :sent_to => 'mcgoo@test.com',
          :requesting_ip= => nil,
          :attribute_values => ['mcgoo@test.com'],
          :errors => mock('Errors', {:full_messages => []}),
          :save => nil
        }).as_new_record
        PasswordReset.stub(:new).and_return(@password_reset)
      end
      
      it "should instantiate a new PasswordReset from params[:password_reset] as @password_reset" do
        PasswordReset.should_receive(:new).with({
          'sent_to' => 'mcgoo@test.com'
        }).and_return(@password_reset)
        
        post :create, :password_reset => {:sent_to => 'mcgoo@test.com'}
        assigns[:password_reset].should == @password_reset
      end
      
      it "stores the client ip" do
        @password_reset.should_receive(:requesting_ip=).with('0.0.0.0')
        post :create
      end
      
      it "should save @password_reset" do
        @password_reset.should_receive(:save)
        post :create
      end
      
      context "save succeeds :)" do
        it "should set a flash[:notice]" do
          @password_reset.stub(:save).and_return(true)
          post :create
          flash[:notice].should_not be_nil
        end
      end
      
      context "save fails :(" do
        it "should set a flash[:warning]" do
          @password_reset.stub(:save).and_return(false)
          post :create
          flash[:warning].should_not be_nil
        end
      end
      
      it "should redirect to new" do
        post :create
        response.should redirect_to(new_password_reset_path)
      end
      
    end
    
    describe ":update, :user => {}" do
      
      before(:each) do
        @user = mock_model(User, {
          :password= => nil,
          :password => nil,
          :password_confirmation= => nil,
          :password_confirmation => nil,
          :errors => mock('Errors', {:full_messages => []}),
          :save => nil
        })
        User.stub(:find_using_perishable_token).and_return(@user)
      end
      
      it "should render edit if any user params are missing" do
        put :update, :id => 'UsersPerishableToken'#, :user => {}
        response.should render_template('password_resets/edit')
      end
      
      it "should load the user with the perishable token" do
        should_load_user{ put :update, :id => 'UsersPerishableToken' }
      end
      
      it "should redirect to the new password reset page if no user loads" do
        User.stub(:find_using_perishable_token).and_return(nil)
        put :update, :id => 'users_perishable_token', :user => {}
        response.should redirect_to(new_password_reset_path)
      end
      
      it "should save the user" do
        @user.should_receive(:save)
        put :update, :id => 'UsersPerishableToken', :user => {}
      end
      
      context "save succeeds :)" do
        
        before(:each) do
          @user.stub(:save).and_return(true)
        end
        
        it "sets flash[:notice]" do
          sets_flash(:notice){ put :update, :id => 'UsersPerishableToken', :user => {} }
        end
        
        it "redirects to the home page" do
          put :update, :id => 'UsersPerishableToken', :user => {}
          response.should redirect_to(root_path)
        end
        
      end
      
      context "save fails :(" do
        
        before(:each) do
          @user.stub(:save).and_return(false)
        end
        
        it "sets flash[:notice]" do
          sets_flash(:notice){ put :update, :id => 'UsersPerishableToken', :user => {} }
        end
        
        it "renders the edit template" do
          put :update, :id => 'UsersPerishableToken', :user => {}
          response.should render_template('password_resets/edit')
        end
        
      end
      
    end
    
  end
  
end
