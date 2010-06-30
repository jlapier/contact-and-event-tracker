class AddModifiedByUserToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :modified_by_user_id, :integer
  end

  def self.down
    remove_column :events, :modified_by_user_id
  end
end
