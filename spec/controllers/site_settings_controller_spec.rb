require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SiteSettingsController do

  def mock_admin_user(stubs={})
    @mock_admin_user ||= mock_model(User, stubs.merge({
      :is_admin? => true,
      :contact => mock_model(Contact, {
        :first_name => 'First',
        :last_name => 'Last',
        :email => 'test@test.com'
      })
    }))
  end

  describe "when logged in as admin" do
    before do
      controller.stub!(:current_user).and_return(mock_admin_user)
    end

    describe "GET index" do
      it "gets the index" do
        get :index
      end
    end

    describe "GET admin" do
      it "gets the admin menu" do
        get :admin
      end
    end
  end
end
