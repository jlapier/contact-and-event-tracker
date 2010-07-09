require 'spec_helper'

describe AccountsController do


  def mock_admin_user(stubs={})
    @mock_admin_user ||= mock_model(User, stubs.merge({:role => 'admin'}))
  end

  def mock_user(stubs={})
    @mock_user ||= mock_model(User, stubs.merge({:role => 'general'}))
  end
  
  context "anonymous users" do
    before(:each) do
      controller.stub(:require_no_user).and_return(true)
    end
    
    describe "register a new user" do
      
      before(:each) do        
        @account = mock_model(User).as_new_record
      end
      
      context "GET :new" do
        it "instantiates a new user as @account" do
          User.should_receive(:new).and_return(@account)
          get :new
          assigns[:account].should == @account
        end
      
        it "renders the new template" do
          get :new
          response.should render_template('accounts/new')
        end
      end
      
      context "POST :create, :user => {}" do
        
        before(:each) do
          @account.stub(:save).and_return(nil)
          User.stub(:new).and_return(@account)
        end
        
        it "instantiates a new user as @account from params[:user]" do
          User.should_receive(:new).and_return(@account)
          post :create
          assigns[:account].should == @account
        end
        
        it "saves the new @account" do
          @account.should_receive(:save)
          post :create
        end
        
        context "save succeeds :)" do
          before(:each) do
            @account.stub(:save).and_return(true)
            @account.stub(:contact_id).and_return(1)
          end
          
          it "sets flash[:notice]" do
            post :create
            flash[:notice].should_not be_nil
          end
          
          it "redirects to the edit contact page" do
            post :create
            response.should redirect_to edit_contact_path(1)
          end
        end
        
        context "save fails :(" do
          before(:each) do
            @account.stub(:save).and_return(false)
          end
          
          it "renders the edit template" do
            post :create
            response.should render_template('accounts/new')
          end
        end
      end
    end # describe 'register a new user'
  end # end context 'anonymous users'
  
  context "authenticated users" do
    before(:each) do
      controller.stub(:current_user_session).and_return(
        mock_model(UserSession, {
          :user => mock_admin_user
        })
      )
    end
    
    describe ":edit" do
      it "loads @current_user as @account" do
        get :edit
        assigns[:account].should == mock_admin_user
      end
      
      it "renders the edit template" do
        get :edit
        response.should render_template('accounts/edit')
      end
    end
    
    describe ":show" do
      it "loads @current_user as @account" do
        get :show
        assigns[:account].should == mock_admin_user
      end
    end
    
    describe ":update, :user => {}" do
      
      before(:each) do
        @mock_admin_user.stub({
          :update_attributes => nil
        })
      end
      
      it "loads @current_user as @account" do
        put :update
        assigns[:account].should == mock_admin_user
      end
      
      it "updates @account" do
        @mock_admin_user.should_receive(:update_attributes)
        put :update
      end
      
      context "update succeeds :)" do
        before(:each) do
          @mock_admin_user.stub(:update_attributes).and_return(true)
        end
        
        it "sets flash[:notice]" do
          put :update
          flash[:notice].should_not be_nil
        end
        
        it "redirects to the account page" do
          put :update
          response.should redirect_to account_path
        end
      end
      
      context "update fails :(" do
        before(:each) do
          @mock_admin_user.stub(:update_attributes).and_return(false)
        end
        
        it "renders the edit template" do
          put :update
          response.should render_template('accounts/edit')
        end
      end
    end
  end
  
end