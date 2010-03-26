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
end
