class AddRoleToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :role, :string, :limit => 25, :default => 'general'
    User.find_all_by_is_admin(true).each do |user|
      user.update_attributes!(:role => 'admin')
    end
  end

  def self.down
    remove_column :users, :role
  end
end
