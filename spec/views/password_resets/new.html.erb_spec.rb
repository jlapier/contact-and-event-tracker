require 'spec_helper'

describe "/password_resets/new" do
  before(:each) do
    assigns[:password_reset] = mock_model(PasswordReset, {
      :sent_to => nil,
      :errors => {:[] => []}
    }).as_new_record
  end
  
  it "renders" do
    render 'password_resets/new'
  end
end
