class CreateFileAttachments < ActiveRecord::Migration
  def self.up
    create_table :file_attachments do |t|
      t.string :name
      t.text :description
      t.string :filepath
      t.integer :event_id

      t.timestamps
    end
    
    add_index :file_attachments, :event_id
  end

  def self.down
    drop_table :file_attachments
  end
end
