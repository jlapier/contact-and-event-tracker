# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  filter_parameter_logging :password, :password_confirmation
  helper_method :current_user_session, :current_user, :logged_in?, :is_admin?, :is_authorized?, :has_authorization?, :current_user_owns_contact?

  before_filter :get_layout
  after_filter :store_location, :except => [:destroy, :create, :update]

  private
    def load_and_authorize_current_user
      unless is_authorized?
        store_location
        if current_user
          logger.debug("Access Denied for Action: #{action_name}, Controller: #{controller_name} by User: #{current_user.name_or_contact_name}; Role: #{current_user.role}")
          flash[:notice] = "Sorry your account is not authorized to do that."
          redirect_to root_path and return
        else
          logger.debug("Access Denied for Action: #{action_name}, Controller: #{controller_name} by Anonymous User")
          flash[:notice] = "Please login to continue."
          redirect_to new_user_session_path and return
        end
        return false
      end
    end
    
    def is_authorized?    
      # todo fix this hack
      return true if action_name =~ /(edit|update)/i &&
                     controller_name =~ /contacts/i &&
                     params[:id] &&
                     current_user_owns_contact?(Contact.find(params[:id]))
      
      has_authorization?
    end
    
    def has_authorization?(aktion=action_name, kontroller=controller_name)
      return false if current_user.nil?
      
      unless AccessPolicy.allows?(current_user.role, aktion, kontroller)
        logger.debug("Access Denied for Action: #{aktion}, Controller: #{kontroller} by User: #{current_user.name_or_contact_name}; Role: #{current_user.role}")
        return false
      else
        return true
      end
    end
    
    def current_user_owns_contact?(contact)
      (current_user and current_user.contact_id and current_user == contact.user)
    end
    
    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end

    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.user
    end

    def logged_in?
      !!current_user
    end

    def is_admin?
      logged_in? and current_user.is_admin?
    end

    def require_user
      unless current_user
        store_location
        flash[:notice] = "You must be logged in to access this page."
        redirect_to new_user_session_path
        return false
      end
    end

    def require_admin_user
      unless is_admin?
        store_location
        flash[:notice] = "You must be an admin to access this page."
        redirect_to new_user_session_path
        return false
      end
    end

    def require_no_user
      if current_user
        store_location
        flash[:notice] = "You must be logged out to access this page."
        redirect_to '/'
        return false
      end
    end

    def store_location
      session[:return_to] = request.request_uri
    end

    def redirect_back_or_default(default)
      unless session[:return_to] && session[:return_to] == new_user_session_path
        redirect_to(session[:return_to] || default)
      else
        redirect_to(default)
      end
      session[:return_to] = nil
    end

    def get_layout
      @css_override = SiteSetting.read_or_write_default_setting 'css override', nil
      @css_override_timestamp = SiteSetting.read_or_write_default_setting 'css override timestamp', nil
    end
end
