require 'spec_helper'

describe "/password_resets/edit" do
  before(:each) do
    assigns[:user] = mock_model(User, {
      :perishable_token => 'UsersPerishableToken',
      :errors => mock('Error', {:[] => []}),
      :password => nil,
      :password_confirmation => nil
    })
    assigns[:password_reset] = mock_model(PasswordReset, {
      :sent_to => nil
    })
  end
  
  it "renders" do
    render 'password_resets/edit'
  end
end
