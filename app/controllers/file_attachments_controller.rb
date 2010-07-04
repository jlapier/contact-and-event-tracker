class FileAttachmentsController < ApplicationController
  
  before_filter :require_admin_user, :except => [:index, :show]
  
  rescue_from Errno::ENOENT, :with => :file_not_found

  private
    def file_not_found(e)
      logger.error("FileAttachmentsController[#{action_name}] was rescued with :file_not_found. #{e.message}")
      flash[:warning] = "The physical file could not be located so your request could not be completed."
      redirect_back_or_default(root_path)
    end
    def redirect_to_index_or_event(params={})
      if defined?(@file_attachment)
        unless @file_attachment.event_id.blank?
          redirect_to(event_path(@file_attachment.event_id, params))
        else
          redirect_to(file_attachments_path(params))
        end
      else
        redirect_back_or_default(root_path(params))
      end
    end
  protected
  public

    def index
      redirect_to root_path
    end
  
    def download
      file_attachment = FileAttachment.find(params[:id])
      file_itself = File.open(file_attachment.full_path, 'r')
      send_data(file_itself.read, :filename => File.basename(file_itself.path), :stream => true, :buffer_size => 1.megabyte)
    end
  
    def create
      if params[:file]
        file_params = {
          :uploaded_file => params[:file]
        }
        file_params.merge!({:event_id => params[:event_id]}) if params[:event_id]
        @file_attachment = FileAttachment.new file_params
      else
        @file_attachment = FileAttachment.new params[:file_attachment]
      end
    
      if @file_attachment.save
        flash[:notice] = "File uploaded."
      else
        flash[:warning] = "Unable to save file attachment: #{@file_attachment.errors.full_messages.join('; ')}"
      end
      unless params[:file] # request.xhr? # html5 based multiple uploads are not xhr ?
        redirect_to_index_or_event(:std => 1) # {:std => 1} - make sure the std html form displays
      else
        render :partial => 'file_attachments/file_attachment', :object => @file_attachment
      end
    end
    
    def edit
      @file_attachment = FileAttachment.find(params[:id])
    end
    
    def update
      @file_attachment = FileAttachment.find(params[:id])
      if @file_attachment.update_attributes(params[:file_attachment])
        flash[:notice] = "Updated File: #{@file_attachment.name}"
        redirect_to_index_or_event
      else
        flash[:warning] = "The description could not be saved, please try again."
        render :edit
      end
    end
    
    def destroy
      @file_attachment = FileAttachment.find(params[:id])
      @file_attachment.destroy
      flash[:notice] = "Deleted File: #{@file_attachment.name}"
      redirect_to_index_or_event
    end
end
