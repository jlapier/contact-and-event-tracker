class MakeAttendeesRevisable < ActiveRecord::Migration
  def self.up
        add_column :attendees, :revisable_original_id, :integer
        add_column :attendees, :revisable_branched_from_id, :integer
        add_column :attendees, :revisable_number, :integer, :default => 0
        add_column :attendees, :revisable_name, :string
        add_column :attendees, :revisable_type, :string
        add_column :attendees, :revisable_current_at, :datetime
        add_column :attendees, :revisable_revised_at, :datetime
        add_column :attendees, :revisable_deleted_at, :datetime
        add_column :attendees, :revisable_is_current, :boolean, :default => 1
      end

  def self.down
        remove_column :attendees, :revisable_original_id
        remove_column :attendees, :revisable_branched_from_id
        remove_column :attendees, :revisable_number
        remove_column :attendees, :revisable_name
        remove_column :attendees, :revisable_type
        remove_column :attendees, :revisable_current_at
        remove_column :attendees, :revisable_revised_at
        remove_column :attendees, :revisable_deleted_at
        remove_column :attendees, :revisable_is_current
  end
end
