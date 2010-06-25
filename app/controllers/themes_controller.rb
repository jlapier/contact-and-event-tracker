class ThemesController < ApplicationController
  before_filter :require_admin_user, :except => [ :css ]
  
  caches_page :css
  
  def index
  end

  def css_editor
    @css = SiteSetting.read_setting('css override') ||
      File.read( File.join(RAILS_ROOT, 'public', 'stylesheets', 'main_elements.css') )
  end

  def update_css
    expire_page "/themes/css/override.css"
    SiteSetting.write_setting('css override', params[:css])
    SiteSetting.write_setting('css override timestamp', Time.now.to_i)
    flash[:notice] = "CSS override updated."
    redirect_to :action => :css_editor
  end

  def css
  end
end
