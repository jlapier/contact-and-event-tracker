class AccountsController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :load_and_authorize_current_user, :except => [:new, :create]
  
  def new
    @account = User.new
  end
  
  def create
    @account = User.new(params[:user])
    if @account.save
      flash[:notice] = "Registered your new account! If you like you can fill out some contact info now, otherwise feel free to explore the site."
      redirect_to edit_contact_path(@account.contact_id)
    else
      render :action => :new
    end
  end
  
  def show
    @account = @current_user
  end

  def edit
    @account = @current_user
  end
  
  def update
    @account = @current_user # makes our views "cleaner" and more consistent
    if @account.update_attributes(params[:user])
      flash[:notice] = "Account updated!"
      redirect_to account_url
    else
      render :action => :edit
    end
  end
  
  # def destroy
  #   user = @current_user
  #   user.destroy
  #   @current_user_session.destroy
  #   flash[:notice] = "Deleted your account"
  #   redirect_to root_url
  # end
  
end