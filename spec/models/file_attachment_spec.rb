require 'spec_helper'

describe FileAttachment do
  
  include ActionController::TestProcess # for fixture_file_upload
  
  before(:each) do
    @path = File.join(RAILS_ROOT, 'public', 'files')
    @full_path = File.join(@path, 'somefile.txt')
    @trash_path = File.join(@path, 'trash', 'somefile.txt')
    
    raise "Please back up and clean out public/files before running this spec" if File.exists?(@full_path) || File.exists?(File.join(@path, 'somefile-1.txt'))
    
    @file_attachment = FileAttachment.create!({
      :description => 'unique description',
      :uploaded_file => fixture_file_upload("somefile.txt", 'text/plain')
    })
  end
  
  after(:each) do  
    if File.exists?(@full_path)
      File.delete(@full_path)
    end
    if File.exists?(@trash_path)
      File.delete(@trash_path)
    end
  end
  
  it "should generate a unique name" do
    FileUtils.mkdir_p @path
    
    new_file = FileAttachment.create!({
      :description => 'other description',
      :uploaded_file => fixture_file_upload("somefile.txt", 'text/plain')
    })
    
    new_file.filepath.should_not == 'files/somefile.txt'
    new_file.filepath.should == 'files/somefile-1.txt'
    File.exists?(@full_path).should be_true
    
    File.delete(File.join(@path, 'somefile-1.txt'))
  end
  
  it "should know whether its file actually exists" do
    @file_attachment.file_saved?.should be_true
    File.exists?(@full_path).should be_true
    File.delete(@full_path)
    @file_attachment.file_saved?.should be_false
  end
  
  it "should move its file to the trash when destroyed" do
    File.exists?(@full_path).should be_true
    @file_attachment.destroy
    File.exists?(@full_path).should be_false
    File.exists?(@trash_path).should be_true
  end
end
