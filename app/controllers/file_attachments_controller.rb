class FileAttachmentsController < ApplicationController
  before_filter :require_admin_user, :except => [:index, :show]

  def create
    @file_attachment = FileAttachment.new params[:file_attachment]

    folder_path = File.join(RAILS_ROOT, 'public', 'files')
    FileUtils.mkdir_p folder_path
    base_filename = File.basename @file_attachment.uploaded_file.original_filename
    new_filename = base_filename
    path = File.join folder_path, new_filename
    count = 0
    until !File.exists? path
      count += 1
      new_filename = base_filename.gsub File.extname(base_filename), "-#{count}#{File.extname(base_filename)}"
      path = File.join folder_path, new_filename
    end

    File.open(path, "wb") { |f| f.write(@file_attachment.uploaded_file.read) }

    if File.exists?(path)
      @file_attachment.filepath = File.join('/files', new_filename)

      if @file_attachment.name.blank?
        @file_attachment.name = @file_attachment.uploaded_file.original_filename
      end

      if @file_attachment.save
        flash[:notice] = "File uploaded."
        if @file_attachment.event
          redirect_to @file_attachment.event
        else
          redirect_to file_attachments_path
        end
      else
        flash[:warning] = "Unable to save file attachment: #{@file_attachment.errors.full_messages.join('; ')}"
        redirect_to @file_attachment.event || file_attachments_path
      end
    else
      flash[:warning] = "Unable to upload file."
      redirect_to file_attachments_path
    end
  end
end
