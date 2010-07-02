class SiteSettingsController < ApplicationController
  before_filter :require_admin_user, :except => [ :homepage ]

  def index
  end

  def homepage
    @homepage_text = SiteSetting.read_or_write_default_setting 'homepage text',
      'TO DO: write home page text (from Admin link on main menu).'
    @file_attachments = FileAttachment.all(:conditions => {:event_id => nil})
  end

  def admin
  end

  def update_site_settings
    SiteSetting.write_setting 'site title', params[:site_title]
    SiteSetting.write_setting 'hostname', params[:hostname]
    SiteSetting.write_setting 'site logo', params[:site_logo]
    SiteSetting.write_setting 'homepage text', params[:homepage_text]
    SiteSetting.write_setting 'site footer', params[:site_footer]
    flash[:notice] = "Site configuration updated."
    redirect_to :action => :index
  end
end
