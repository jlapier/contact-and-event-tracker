class MakeContactsRevisable < ActiveRecord::Migration
  def self.up
        add_column :contacts, :revisable_original_id, :integer
        add_column :contacts, :revisable_branched_from_id, :integer
        add_column :contacts, :revisable_number, :integer, :default => 0
        add_column :contacts, :revisable_name, :string
        add_column :contacts, :revisable_type, :string
        add_column :contacts, :revisable_current_at, :datetime
        add_column :contacts, :revisable_revised_at, :datetime
        add_column :contacts, :revisable_deleted_at, :datetime
        add_column :contacts, :revisable_is_current, :boolean, :default => 1
      end

  def self.down
        remove_column :contacts, :revisable_original_id
        remove_column :contacts, :revisable_branched_from_id
        remove_column :contacts, :revisable_number
        remove_column :contacts, :revisable_name
        remove_column :contacts, :revisable_type
        remove_column :contacts, :revisable_current_at
        remove_column :contacts, :revisable_revised_at
        remove_column :contacts, :revisable_deleted_at
        remove_column :contacts, :revisable_is_current
      end
end
