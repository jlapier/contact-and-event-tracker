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

  describe "when logged in as admin" do
    before do
      controller.stub!(:current_user).and_return(mock_admin_user)
    end

    it "should upload a new file attachment" do
      params = { :description => "blah blah", :name => "agenda",
        :uploaded_file => some_file,
        :event_id => mock_event.id }

      FileAttachment.stub(:new).and_return(mock_file_attachment)

      post :create, :file_attachment => params

      response.should redirect_to(event_url(mock_event))
    end
  end

end
