# events
# t.string   "name"
# t.string   "event_type"
# t.date     "start_on"
# t.date     "end_on"
# t.text     "location"
# t.text     "description"
# t.datetime "created_at"
# t.datetime "updated_at"
# t.text     "notes"

class MakeEventsRevisable < ActiveRecord::Migration
  def self.up
        add_column :events, :revisable_original_id, :integer
        add_column :events, :revisable_branched_from_id, :integer
        add_column :events, :revisable_number, :integer, :default => 0
        add_column :events, :revisable_name, :string
        add_column :events, :revisable_type, :string
        add_column :events, :revisable_current_at, :datetime
        add_column :events, :revisable_revised_at, :datetime
        add_column :events, :revisable_deleted_at, :datetime
        add_column :events, :revisable_is_current, :boolean, :default => 1
      end

  def self.down
        remove_column :events, :revisable_original_id
        remove_column :events, :revisable_branched_from_id
        remove_column :events, :revisable_number
        remove_column :events, :revisable_name
        remove_column :events, :revisable_type
        remove_column :events, :revisable_current_at
        remove_column :events, :revisable_revised_at
        remove_column :events, :revisable_deleted_at
        remove_column :events, :revisable_is_current
      end
end
