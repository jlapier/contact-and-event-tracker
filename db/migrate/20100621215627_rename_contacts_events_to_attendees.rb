class RenameContactsEventsToAttendees < ActiveRecord::Migration
  def self.up
    rename_table :contacts_events, :attendees
    add_column :attendees, :id, :primary_key
  end

  def self.down
    rename_table :attendees, :contacts_events
    drop_column :contacts_events, :id
  end
end
