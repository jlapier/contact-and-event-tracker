class ContactGroupsController < ApplicationController
  before_filter :load_and_authorize_current_user, :except => [:index, :show]

  # GET /contact_groups
  # GET /contact_groups.xml
  def index
    @contact_groups = ContactGroup.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @contact_groups }
    end
  end

  def emails    
    respond_to do |format|
      format.html { redirect_to contact_groups_url }
      format.js do
        contact_groups = [ContactGroup.find(params[:contact_group_ids])].flatten
        render :json => contact_groups.map(&:contacts).flatten.uniq.map(&:email).to_json
      end
    end
  end

  # GET /contact_groups/1
  # GET /contact_groups/1.xml
  def show
    @contact_group = ContactGroup.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @contact_group }
    end
  end

  # GET /contact_groups/new
  # GET /contact_groups/new.xml
  def new
    @contact_group = ContactGroup.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @contact_group }
    end
  end

  # GET /contact_groups/1/edit
  def edit
    @contact_group = ContactGroup.find(params[:id])
  end

  # POST /contact_groups
  # POST /contact_groups.xml
  def create
    @contact_group = ContactGroup.new(params[:contact_group])

    respond_to do |format|
      if @contact_group.save
        flash[:notice] = "Contact group <em>#{@contact_group.name}</em> created."
        format.html { redirect_to(@contact_group) }
        format.xml  { render :xml => @contact_group, :status => :created, :location => @contact_group }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @contact_group.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /contact_groups/1
  # PUT /contact_groups/1.xml
  def update
    @contact_group = ContactGroup.find(params[:id])

    respond_to do |format|
      if @contact_group.update_attributes(params[:contact_group])
        flash[:notice] = "Contact group <em>#{@contact_group.name}</em> updated."
        format.html { redirect_to(@contact_group) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @contact_group.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /contact_groups/1
  # DELETE /contact_groups/1.xml
  def destroy
    @contact_group = ContactGroup.find(params[:id])
    @contact_group.destroy

    respond_to do |format|
      format.html { redirect_to(contact_groups_url) }
      format.xml  { head :ok }
    end
  end

  def drop_contact
    @contact_group = ContactGroup.find(params[:id])
    if @contact_group.drop_contacts(params[:contact_ids] || params[:contact_id])
      flash[:notice] = "Contact(s) dropped from #{@contact_group.name}."
    else
      flash[:warning] = "Failed to drop contact(s) from #{@contact_group.name}. (#{@contact_group.errors.full_messages.join('; ')}"
    end
    redirect_to @contact_group
  end

  def add_members
    @contact_group = ContactGroup.find(params[:id])
    if params[:q]
      all_contacts = Contact.search(params[:q], :order => 'last_name, first_name',
        :narrow_fields => params[:fields] ? params[:fields].keys : nil)
    else
      all_contacts = Contact.find(:all, :order => 'last_name, first_name',
        :conditions => 'last_name IS NOT NULL AND last_name != ""')
    end

    @contacts_not_in_group =  all_contacts - @contact_group.contacts
  end

  def add_contacts
    @contact_group = ContactGroup.find(params[:id])
    @contact_group.contacts += Contact.find(params[:contact_ids])
    if @contact_group.save
      flash[:notice] = "Contacts(s) added to #{@contact_group.name}."
    else
      flash[:warning] = "Failed to add contact(s) to #{@contact_group.name}. (#{@contact_group.errors.full_messages.join('; ')}"
    end
    redirect_to @contact_group
  end
end
