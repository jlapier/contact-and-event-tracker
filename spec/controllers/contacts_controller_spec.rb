require 'spec_helper'

describe ContactsController do

  def mock_admin_user(stubs={})
    @mock_admin_user ||= mock_model(User, stubs.merge({:role => 'admin', :name_or_contact_name => 'john'}))
  end

  def mock_user(stubs={})
    @mock_user ||= mock_model(User, stubs.merge({:role => 'general', :name_or_contact_name => 'joe'}))
  end

  def mock_contact(stubs={})
    @mock_contact ||= mock_model(Contact, stubs.merge(:first_name => "joe", :name => "joe", :user => mock_user, :update_attributes => nil))
  end

  def mock_other_contact(stubs={})
    @mock_other_contact ||= mock_model(Contact, stubs.merge(:first_name => "john", :name => "john", :user => mock_admin_user, :update_attributes => nil))
  end

  describe "when logged in as admin" do
    before do
      controller.stub(:is_authorized?).and_return(true)
    end

    describe "GET index" do
      it "assigns contacts as @contacts" do
        Contact.stub!(:paginate).and_return([mock_contact].paginate)
        get :index
        assigns[:contacts].should == [mock_contact]
      end
    end

    describe "GET show" do
      it "assigns the requested contact as @contact" do
        Contact.stub!(:find).with("37").and_return(mock_contact)
        get :show, :id => "37"
        assigns[:contact].should equal(mock_contact)
      end
    end

    describe "GET new" do
      it "assigns a new contact as @contact" do
        Contact.stub!(:new).and_return(mock_contact)
        get :new
        assigns[:contact].should equal(mock_contact)
      end
    end

    describe "GET edit" do
      it "assigns the requested contact as @contact" do
        Contact.stub!(:find).with("37").and_return(mock_contact)
        get :edit, :id => "37"
        assigns[:contact].should equal(mock_contact)
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "assigns a newly created contact as @contact" do
          Contact.stub!(:new).with({'these' => 'params'}).and_return(mock_contact(:save => true))
          post :create, :contact => {:these => 'params'}
          assigns[:contact].should equal(mock_contact)
        end

        it "redirects to the created contact" do
          Contact.stub!(:new).and_return(mock_contact(:save => true))
          post :create, :contact => {}
          response.should redirect_to(contact_url(mock_contact))
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved contact as @contact" do
          Contact.stub!(:new).with({'these' => 'params'}).and_return(mock_contact(:save => false))
          post :create, :contact => {:these => 'params'}
          assigns[:contact].should equal(mock_contact)
        end

        it "re-renders the 'new' template" do
          Contact.stub!(:new).and_return(mock_contact(:save => false))
          post :create, :contact => {}
          response.should render_template('new')
        end
      end
    end

    describe "PUT update" do
      before(:each) do
        controller.stub(:is_authorized?).and_return(true)
        Contact.stub(:find).and_return(mock_contact)
      end
      
      describe "with valid params" do
        it "updates the requested contact" do
          Contact.should_receive(:find).with('37').any_number_of_times.and_return(mock_contact)
          mock_contact.should_receive(:update_attributes).with({'these' => 'params'})
          put :update, :id => "37", :contact => {:these => 'params'}
        end

        it "assigns the requested contact as @contact" do
          Contact.stub!(:find).and_return(mock_contact(:update_attributes => true))
          put :update, :id => "1"
          assigns[:contact].should equal(mock_contact)
        end

        it "redirects to the contact" do
          mock_contact.stub(:update_attributes).and_return(true)
          put :update, :id => mock_contact.id
          response.should redirect_to(contact_url(mock_contact))
        end
      end

      describe "with invalid params" do
        it "updates the requested contact" do
          Contact.should_receive(:find).with("37").and_return(mock_contact)
          mock_contact.should_receive(:update_attributes).with({'these' => 'params'})
          put :update, :id => "37", :contact => {:these => 'params'}
        end

        it "assigns the contact as @contact" do
          Contact.stub!(:find).and_return(mock_contact(:update_attributes => false))
          put :update, :id => "1"
          assigns[:contact].should equal(mock_contact)
        end

        it "re-renders the 'edit' template" do
          Contact.stub!(:find).and_return(mock_contact(:update_attributes => false))
          put :update, :id => "1"
          response.should render_template('edit')
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested contact" do
        Contact.should_receive(:find).with("37").and_return(mock_contact)
        mock_contact.should_receive(:destroy)
        delete :destroy, :id => "37"
      end

      it "redirects to the contacts list" do
        Contact.stub!(:find).and_return(mock_contact(:destroy => true))
        delete :destroy, :id => "1"
        response.should redirect_to(contacts_url)
      end
    end
  end
  
  describe "when logged in as regular user" do
    before do
      @user = mock_model(User, {:role => 'asdf', :name_or_contact_name => 'general joe'})
      controller.stub(:current_user).and_return(@user)
      controller.stub(:current_user_session).and_return(mock_model(UserSession, {
        :user => @user
      }))
    end
    
    describe "GET index" do
      it "assigns contacts as @contacts" do
        Contact.stub!(:paginate).and_return([mock_contact].paginate)
        get :index
        assigns[:contacts].should == [mock_contact]
      end
    end

    describe "GET show" do
      it "assigns the requested contact as @contact" do
        Contact.stub!(:find).with("37").and_return(mock_contact)
        get :show, :id => "37"
        assigns[:contact].should equal(mock_contact)
      end
    end

    describe "GET new" do
      it "redirects to root" do
        get :new
        response.should redirect_to(root_path)
      end
    end

    describe "GET edit" do
      before(:each) do
        @contact = mock_model(Contact)
        @user.stub(:contact_id => @contact.id)
      end
      
      it "is not allowed if not user owned contact" do
        Contact.stub!(:find).with("3").and_return(mock_other_contact)
        get :edit, :id => "3"
        response.should redirect_to(root_path)
      end
      
      it "assigns the requested contact as @contact" do
        Contact.stub!(:find).with("37").and_return(mock_contact)
        controller.stub(:has_authorization?).and_return(true)
        get :edit, :id => "37"
        assigns[:contact].should == mock_contact
      end
    end
    
    describe "PUT update" do
      before(:each) do
        controller.stub(:is_authorized?).and_return(true)
      end
      
      describe "with valid params" do
        it "updates the requested contact" do
          Contact.should_receive(:find).with("37").and_return(mock_contact)
          mock_contact.should_receive(:update_attributes).with({'these' => 'params'})
          put :update, :id => "37", :contact => {:these => 'params'}
        end

        it "assigns the requested contact as @contact" do
          Contact.stub(:find).and_return(mock_contact(:update_attributes => true))
          put :update, :id => "1"
          assigns[:contact].should equal(mock_contact)
        end

        it "redirects to the contact" do
          mock_contact.stub(:update_attributes => true)
          Contact.stub(:find).and_return(mock_contact)
          put :update, :id => mock_contact.id
          response.should redirect_to(contact_url(mock_contact))
        end
      end

      describe "with invalid params" do
        it "updates the requested contact" do
          Contact.should_receive(:find).with("37").and_return(mock_contact)
          mock_contact.should_receive(:update_attributes).with({'these' => 'params'})
          put :update, :id => "37", :contact => {:these => 'params'}
        end

        it "assigns the contact as @contact" do
          Contact.stub!(:find).and_return(mock_contact(:update_attributes => false))
          put :update, :id => "1"
          assigns[:contact].should equal(mock_contact)
        end

        it "re-renders the 'edit' template" do
          Contact.stub!(:find).and_return(mock_contact(:update_attributes => false))
          put :update, :id => "1"
          response.should render_template('edit')
        end
      end
    end

    describe "DELETE destroy" do
      before(:each) do
        controller.stub(:is_authorized?).and_return(false)
        Contact.should_not_receive(:find)
      end
      it "redirects to root (authorization)" do
        delete :destroy, :id => "1"
        response.should redirect_to(root_path)
      end
      
    end
  end

  describe "when not logged in" do
    before do
      controller.stub(:is_authorized?).and_return(false)
    end

    describe "GET index" do
      it "assigns contacts as @contacts" do
        Contact.stub!(:paginate).and_return([mock_contact].paginate)
        get :index
        assigns[:contacts].should == [mock_contact]
      end
    end

    describe "GET show" do
      it "assigns the requested contact as @contact" do
        Contact.stub!(:find).with("37").and_return(mock_contact)
        get :show, :id => "37"
        assigns[:contact].should equal(mock_contact)
      end
    end

    describe "GET new" do
      it "redirects to login" do
        get :new
        response.should redirect_to(new_user_session_url)
      end
    end

    describe "GET edit" do
      it "redirects to login" do
        Contact.should_not_receive(:find)
        get :edit, :id => "1"
        response.should redirect_to(new_user_session_url)
      end
    end

    describe "POST create" do
      describe "with any params" do
        it "redirects to index" do
          post :create, :contact => {:these => 'params'}
          response.should redirect_to(new_user_session_url)
        end
      end
    end

    describe "PUT update" do
      describe "with any params" do
        it "redirects to index" do
          Contact.should_not_receive(:find)
          put :update, :id => "37", :contact => {:these => 'params'}
          response.should redirect_to(new_user_session_url)
        end
      end
    end

    describe "DELETE destroy" do
      it "redirects to index" do
        delete :destroy, :id => "37"
        response.should redirect_to(new_user_session_url)
      end

      it "should not delete any contacts" do
        Contact.should_not_receive(:find)
        delete :destroy, :id => "1"
      end
    end
  end
end
