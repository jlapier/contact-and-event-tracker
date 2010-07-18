class PasswordResetsController < ApplicationController
  
  before_filter :require_no_user
  before_filter { |controller| controller.send(:restart) if controller.action_name == 'index' }
  before_filter :load_user_or_restart, :only => [:show, :update]
  
  rescue_from ActiveRecord::RecordNotFound, :with => :restart
  
  private
    def load_user
      @user = User.find_using_perishable_token(params[:id], 24.hours)
    end
    def restart(msg='Please submit your email to reset your password.')
      session[:password_reset_submitted] = nil
      flash[:notice] = msg
      redirect_to new_password_reset_path
    end
    def load_user_or_restart
      load_user
      restart if @user.nil?
    end
  protected
  public
    def new
      @submitted = session[:password_reset_submitted] || false
      session[:password_reset_submitted] = nil
      @password_reset = PasswordReset.new
    end

    def create
      @password_reset = PasswordReset.new(params[:password_reset])
      @password_reset.requesting_ip = request.env['REMOTE_ADDR'] || request.env['HTTP_X_FORWARDED_FOR']
    
      if @password_reset.save
        flash[:notice] = "An email has been sent to #{@password_reset.sent_to}. Follow the link in the email to confirm that you receive mail at that address and we will continue to reset your password."
        session[:password_reset_submitted] = true
      else
        flash[:warning] = 'There was an error with your request. Please try again.'
        logger.error("Invalid Password Reset: #{@password_reset.errors.full_messages.join('; ')} -- #{@password_reset.attribute_values.join('; ')}")
      end
      redirect_to new_password_reset_path
    end
  
    # using show to render edit for cleaner uri
    def show
      if @user.password_reset_confirmed(request.env['REMOTE_ADDR'] || request.env['HTTP_X_FORWARDED_FOR'])
        flash[:notice] = 'Create a new password.'
        render :edit and return
      else
        restart('There was an error with your request. Please try again.')
      end
    end

    def update
      render :edit and return unless params[:user]
      @user.password = params[:user][:password]
      @user.password_confirmation = params[:user][:password_confirmation]
      if @user.save
        flash[:notice] = "Your password has been changed."
        redirect_to root_path
      else
        flash[:notice] = "Please correct any errors and try again."
        render :edit
      end
    end
end
