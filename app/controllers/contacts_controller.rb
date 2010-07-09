class ContactsController < ApplicationController
  before_filter :load_and_authorize_current_user, :except => [:index, :show, :search]

  def index
    @contacts = Contact.paginate :all, :page => params[:page], :per_page => params[:per_page] || 30,
      :conditions => "last_name IS NOT NULL and last_name !=''", :order => 'last_name, first_name'

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @contacts }
    end
  end

  def search
    @contacts = Contact.search(params[:q], :order => 'last_name, first_name',
      :narrow_fields => params[:fields] ? params[:fields].keys : nil).paginate :page => params[:page]
          
    respond_to do |format|
      format.html { render :action => :index }
      format.xml  { render :xml => @contacts }
    end
  end

  def show
    @contact = Contact.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @contact }
    end
  end

  def new
    @contact = Contact.new
    if params[:user_id]
      @user = User.find params[:user_id]
      @contact.user = @user
    end
  end

  def edit
    @contact = Contact.find params[:id]
    unless has_authorization?(:update, :contacts) or @contact.user == current_user
      redirect_to(contacts_url)
    end
  end

  def create
    @contact = Contact.new params[:contact]
    
    respond_to do |format|
      if @contact.save
        flash[:notice] = "Contact <em>#{@contact.name}</em> created."
        format.html { redirect_to(@contact) }
        format.xml  { render :xml => @contact, :status => :created, :location => @contact }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @contact.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @contact = Contact.find(params[:id])

    if is_authorized? || (@contact.user and @contact.user == current_user)
      respond_to do |format|
        if @contact.update_attributes(params[:contact])
          flash[:notice] = "Contact <em>#{@contact.name}</em> updated."
          format.html { redirect_to(@contact) }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @contact.errors, :status => :unprocessable_entity }
        end
      end
    else
      redirect_to contacts_url
    end
  end

  def destroy
    @contact = Contact.find(params[:id])
    @contact.destroy

    respond_to do |format|
      format.html { redirect_to(contacts_url) }
      format.xml  { head :ok }
    end
  end
end
