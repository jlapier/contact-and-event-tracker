class CreateContactGroups < ActiveRecord::Migration
  def self.up
    create_table :contact_groups do |t|
      t.string :name

      t.timestamps
    end
    
    create_table :contact_groups_contacts, :id => false do |t|
      t.integer :contact_id
      t.integer :contact_group_id
    end
  end

  def self.down
    drop_table :contact_groups
  end
end
