# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def site_title
    "Contact and Event Tracker"
  end

  def page_title
    if controller.controller_name == "user_sessions"
      pt = ''
    else
      pt = "#{controller.controller_name.humanize}"
      pt += " - #{@contact.name}" if @contact
      pt += " - #{@contact_group.name}" if @contact_group
      pt += " - #{@event.name}" if @event
    end
    pt
  end
  
  # wrapper to completely hide contact emails from anonymous users
  # pass :public => true along w/ the html_options to display email regardless
  def mail_to(email_address, name=nil, html_options={})
    public_address = html_options.has_key?(:public) ? html_options.delete(:public) : nil
    if public_address or logged_in?
      super(email_address, name, html_options)
    else
      content_tag(:span, "#{link_to('log in', new_user_session_path)} to view emails", :style => "padding: 3px; background-color: gray; color: white;")
    end
  end
end
