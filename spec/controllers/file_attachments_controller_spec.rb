require 'spec_helper'

describe FileAttachmentsController do
  def mock_event(stubs={})
    @mock_event ||= mock_model(Event, stubs)
  end

  def mock_admin_user(stubs={})
    @mock_admin_user ||= mock_model(User, stubs.merge({:is_admin? => true}))
  end

  def mock_user(stubs={})
    @mock_user ||= mock_model(User, stubs.merge({:is_admin? => false}))
  end

  def mock_file_attachment
    @mock_file_attachment ||= mock_model(FileAttachment, :event => mock_event,
      :uploaded_file => some_file, :filepath= => nil, :name => 'what', :save => true)
  end

  def some_file
    fixture_file_upload("somefile.txt", 'text/plain')
  end
  
  def it_redirects_back(&block)
    session[:return_to] = 'http://example.com/contacts'
    yield
    response.should redirect_to('http://example.com/contacts')
  end

  describe "when logged in as admin" do
    before do
      controller.stub!(:current_user).and_return(mock_admin_user)
      FileAttachment.stub(:new).and_return(mock_file_attachment)
      @params = { :description => "blah blah", :name => "agenda",
        :uploaded_file => some_file,
        :event_id => mock_event.id }
    end
    
    context "http upload" do
      it "should upload a new file attachment with an event" do
        FileAttachment.should_receive(:new).and_return(mock_file_attachment)
        post :create, :file_attachment => @params
        response.should redirect_to(event_url(mock_event, :std => 1))
      end
      it "should upload a new file attachment without an event" do
        @params.merge!(:event_id => '')
        mock_file = mock_model(FileAttachment, @params.merge({:save => nil, :event => '', :errors => mock('Error', {:full_messages => []})}))
        FileAttachment.should_receive(:new).and_return(mock_file)
        post :create, :file_attachment => @params
      end
      it "should save the new file attachment" do
        mock_file_attachment.should_receive(:save)
        post :create, :file_attachment => @params
      end
    end
    
    context "plupload" do
      
      before(:each) do
        @params.delete(:name) && @params.delete(:description)
      end
      
      it "should upload a new file attachment with an event" do
        FileAttachment.should_receive(:new).and_return(mock_file_attachment)
        
        post :create, {
          :file => some_file,
          :event_id => mock_event.id
        }
        
        assigns[:file_attachment].should == mock_file_attachment
        
        response.should render_template('file_attachments/_file_attachment')
      end
      
      it "should upload a new file attachment without an event" do
        post :create, {
          :file => some_file
        }
        
        assigns[:file_attachment].should == mock_file_attachment
      end
    end
    
    context "delete a file" do
      
      before(:each) do
        controller.stub(:current_user).and_return(mock_admin_user)
        FileAttachment.stub(:find).and_return(mock_file_attachment)
        mock_file_attachment.stub(:full_path).and_return(File.join(RAILS_ROOT, 'spec', 'fixtures', 'somefile.txt'))
        mock_file_attachment.stub(:destroy).and_return(mock_file_attachment)
        File.stub(:rm)
      end
      
      it "load the file attachment" do
        FileAttachment.should_receive(:find).and_return(mock_file_attachment)
        post :destroy, :id => 1
        assigns[:file_attachment].should == mock_file_attachment
      end
      
      it "destroys the file attachment" do
        mock_file_attachment.should_receive(:destroy)
        post :destroy, :id => 1
      end
      
      it "sets a flash[:notice]" do
        post :destroy, :id => 1
        flash[:notice].should_not be_nil
      end
      
      it "redirects back" do
        it_redirects_back{ post :destroy, :id => 1 }
      end
      
      it "OR to root_path" do
        post :destroy, :id => 1
        response.should redirect_to('http://test.host/') # < wtf?!
      end
      
    end

  end
  
  describe "when Errno::ENOENT is raised" do
    
    before(:each) do
      controller.stub(:current_user).and_return(mock_admin_user)
      FileAttachment.stub(:find).and_return(mock_file_attachment)
      mock_file_attachment.stub(:destroy).and_raise(Errno::ENOENT.new("File not found"))
    end
    
    it "logs the error" do
      controller.logger.should_receive(:error).with("FileAttachmentsController[destroy] was rescued with :file_not_found. No such file or directory - File not found")
      post :destroy, :id => 1
    end
    
    it "sets a flash[:warning]" do
      post :destroy, :id => 1
      flash[:warning].should_not be_nil
    end
    
    it "redirects back" do
      it_redirects_back{ post :destroy, :id => 1 }
    end
    
    it "OR to root_path" do
      post :destroy, :id => 1
      response.should redirect_to('http://test.host/')
    end
    
  end
  
  describe "when visiting anonymously" do
    
    before(:each) do
      controller.stub!(:current_user).and_return(mock_admin_user)
      FileAttachment.stub(:find).and_return(mock_file_attachment)
      mock_file_attachment.stub(:full_path).and_return(File.join(RAILS_ROOT, 'spec', 'fixtures', 'somefile.txt'))
    end
    
    it "file attachments should be visible to anonymous users"
    
    it "sends files to clients" do
      controller.should_receive(:send_data)
      get :download, :id => mock_file_attachment.id
    end
    
  end

end
