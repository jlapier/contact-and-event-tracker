require 'spec_helper'

describe ThemesController do

  #Delete these examples and add some real ones
  it "should use ThemesController" do
    controller.should be_an_instance_of(ThemesController)
  end

  describe "GET 'css'" do
    it "should be successful" do
      get 'css'
      response.should be_success
    end
  end

end
