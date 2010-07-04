# t.string   "name"
# t.text     "description"
# t.string   "filepath"
# t.integer  "event_id"
# t.datetime "created_at"
# t.datetime "updated_at"

class FileAttachment < ActiveRecord::Base
  
  FOLDER = 'files'
  FOLDER_ROOT = File.join(RAILS_ROOT, 'public')
  FOLDER_PATH = File.join(FOLDER_ROOT, FOLDER)
  TRASH_FOLDER = File.join(FOLDER_PATH, 'trash')
  
  validates_presence_of :name, :filepath
  
  belongs_to :event
  
  before_validation_on_create :autofill_blank_name
  before_validation_on_create :save_to_folder_path
  # before_validation_on_update :autofill_blank_name, :if => :file_uploaded?
  # before_validation_on_update :save_to_folder_path, :if => :file_uploaded?
  before_destroy :move_file_to_trash_folder!
  
  acts_as_stripped :description, :name

  attr_accessor :uploaded_file
  
  private
    def move_file_to_trash_folder!
      ensure_folder_path_exists(TRASH_FOLDER)
      trash_filename = generate_unique_filename(TRASH_FOLDER)
      
      FileUtils.mv(full_path, File.join(TRASH_FOLDER, trash_filename))
      
      unless File.exists?(File.join(TRASH_FOLDER, trash_filename))
        raise Errno::ENOENT("The file at #{File.join(FOLDER_ROOT, filepath)} should be in the trash at #{File.join(TRASH_FOLDER, trash_filename)}")
      end
      logger.info("Moved File Attachment to Trash: #{File.join(TRASH_FOLDER, trash_filename)}")
    end
    def save_to_folder_path
      ensure_folder_path_exists
      build_filepath
      File.open(full_path, "wb") { |f| f.write(uploaded_file.read) }
      return true if file_saved?
      errors.add_to_base("The file could not be saved. Please try again or contact someone and make a note of how many files, what kind, etc.")
      false
    end
    def generate_unique_filename(dest_path=FOLDER_PATH)
      base_filename = File.basename(uploaded_file && uploaded_file.original_filename || filepath)
      new_filename = base_filename
      path = File.join dest_path, new_filename
      count = 0
      until !File.exists? path
        count += 1
        new_filename = base_filename.gsub File.extname(base_filename), "-#{count}#{File.extname(base_filename)}"
        path = File.join dest_path, new_filename
      end
      new_filename
    end
    def ensure_folder_path_exists(dest_path=FOLDER_PATH)
      FileUtils.mkdir_p dest_path
    end
    def build_filepath
      self.filepath = File.join FOLDER, generate_unique_filename
    end
    def autofill_blank_name
      if name.blank?
        self.name = self.uploaded_file.original_filename
      end
    end
  protected
  public
    def full_path
      "#{FOLDER_ROOT}/#{filepath}"
    end
    def file_saved?
      return true if File.exists?(full_path) && File.basename(full_path) != FOLDER
      return false
    end
end
