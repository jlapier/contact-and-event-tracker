class FileAttachmentsController < ApplicationController
  
  before_filter :require_admin_user, :except => [:index, :show]

  private
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
      respond_to do |format|
        unless params[:file]
          format.html{ redirect_to @file_attachment.event || file_attachments_path }
        else
          format.js
        end
      end
    end
end
