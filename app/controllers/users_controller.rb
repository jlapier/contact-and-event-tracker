class UsersController < ApplicationController
  before_filter :load_and_authorize_current_user

  def new
    @user = User.new
  end
  
  def index
    @users = User.all(:order => 'email')
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      #flash[:notice] = "New account notification sent to #{@user.email}!"
      flash[:notice] = "Account registered for #{@user.email}!"
      redirect_to user_url(@user.id)
    else
      render :action => :new
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:notice] = "Account updated!"
      redirect_to user_url(@user.id)
    else
      render :action => :edit
    end
  end
  
  def destroy
    user = User.find(params[:id])
    user.destroy
    flash[:notice] = "Deleted #{user.name_or_contact_name}'s account"
    redirect_to users_url
  end
end
