class FileAttachment < ActiveRecord::Base
  validates_presence_of :name, :filepath
  
  belongs_to :event

  attr_accessor :uploaded_file
  
end
