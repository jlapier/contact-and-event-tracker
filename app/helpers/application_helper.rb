# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def is_current_user?(user)
    current_user == user
  end

  def site_title
    @site_title ||= SiteSetting.read_setting('site title') || "Contact and Event Tracker"
  end

  def logo_image
    image_tag(site_logo)
  end

  def site_logo
    @site_logo ||= SiteSetting.read_setting('site logo') || "GenericLogo.png"
  end

  def images_list
    Dir[File.join(RAILS_ROOT, 'public', 'images', "*.{png,jpg,gif}")].map { |f| File.basename f }.sort
  end
  
  def page_title
    if controller.controller_name == "user_sessions" or controller.action_name == "homepage"
      pt = ''
    else
      pt = "#{controller.controller_name.humanize}"
      pt += " - #{@contact.name}" if @contact
      pt += " - #{@contact_group.name}" if @contact_group
      pt += " - #{@event.name}" if @event
    end
    pt
  end

  def site_footer
    @site_footer ||= SiteSetting.read_setting('site footer') ||
      "Content on this site is the copyright of the owners of #{request.host} and is provided as-is without warranty."
  end
  
  # wrapper to completely hide contact emails from anonymous users
  # pass :public => true along w/ the html_options to display email regardless
  def mail_to(email_address, name=nil, html_options={})
    public_address = html_options.has_key?(:public) ? html_options.delete(:public) : nil
    if public_address or logged_in?
      super(email_address, name, html_options)
    else
      content_tag(:span, "#{link_to('login', new_user_session_path)} to view emails", :style => "padding: 3px; background-color: gray; color: white;")
    end
  end
end
