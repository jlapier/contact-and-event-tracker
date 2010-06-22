# t.string   "name"
# t.text     "description"
# t.string   "filepath"
# t.integer  "event_id"
# t.datetime "created_at"
# t.datetime "updated_at"

class FileAttachment < ActiveRecord::Base
  validates_presence_of :name, :filepath
  
  belongs_to :event

  attr_accessor :uploaded_file
  
end
