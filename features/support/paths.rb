module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name

    when /the home\s?page/
      '/'
    when /the login page/
      new_user_session_path
    when /the new events? page/
      new_event_path
    when /edit the event "(.*)"/
      edit_event_path(Event.find_by_name($1).id)
    when /the event page for "(.*)"/
      event_path(Event.find_by_name($1).id)
    when /the users page/
      users_path
    when /the new users? page/
      new_user_path
    when /edit the user "(.*)"/
      edit_user_path(User.find_by_email($1).id)
    when /the contact page for "(.*)"/
      first, last = $1.split(' ')
      contact_path(Contact.find_by_first_name_and_last_name(first, last).id)
    when /edit the contact "(.*)"/
      first, last = $1.split(' ')
      edit_contact_path(Contact.find_by_first_name_and_last_name(first, last).id)
    when /the contact group page for "(.*)"/
      contact_group_path(ContactGroup.find_by_name($1).id)

    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      begin
        page_name =~ /the (.*) page/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue Object => e
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)
