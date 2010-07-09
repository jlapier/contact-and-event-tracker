require 'spec_helper'

describe UsersController do

  before(:each) do
    controller.stub(:load_and_authorize_current_user).and_return(true)
  end

  context "GET" do
        
    describe ":new" do
      before(:each) do
        @user = mock_model(User).as_new_record
        User.stub(:new).and_return(@user)
      end
      
      it "instantiates a new User as @user" do
        User.should_receive(:new).and_return(@user)
        get :new
        assigns[:user].should == @user
      end
      
      it "renders the new template" do
        get :new
        response.should render_template('users/new')
      end
      
    end
    
    describe ":index" do
      before(:each) do
        @user = mock_model(User, {
          :name_or_contact_name => 'first last',
          :name => 'first last',
          :contact_id => nil
        })
        User.stub(:all).and_return([@user])
      end
      
      it "loads all Users as @users" do
        User.should_receive(:all).and_return([@user])
        get :index
        assigns[:users].should == [@user]
      end
      
      it "renders the index template" do
        get :index
        response.should render_template('users/index')
      end
      
    end
    
  end
  
  context "POST" do
    
    describe ":destroy, :id => integer" do
      
      before(:each) do
        @user = mock_model(User, {
          :name_or_contact_name => 'Joe Schmo',
          :destroy => nil
        })
        User.stub(:find).and_return(@user)
      end
      
      it "loads a user as @user" do
        User.should_receive(:find).and_return(@user)
        post :destroy, :id => 1
      end
      
      it "destroys the user" do
        @user.should_receive(:destroy)
        post :destroy, :id => 1
      end
      
      it "sets a flash[:notice]" do
        post :destroy, :id => 1
        flash[:notice].should_not be_nil
      end
      
      it "redirects to the users page" do
        post :destroy, :id => 1
        response.should redirect_to users_path
      end
      
    end
    
  end

end
