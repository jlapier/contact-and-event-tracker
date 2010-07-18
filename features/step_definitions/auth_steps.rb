Given /^I am not logged in$/ do
end

Given /^I am logged in as a "([^"]*)" user$/ do |role|
  user = User.find_by_role(role)
  visit new_user_session_path
  fill_in("E-mail Address", :with => user.email)
  fill_in("Password", :with => "adude-73")
  click_button "Log in"
end