class AddModifiedByUserToContacts < ActiveRecord::Migration
  def self.up
    add_column :contacts, :integer, :modified_by_user_id
  end

  def self.down
    remove_column :contacts, :modified_by_user_id
  end
end
