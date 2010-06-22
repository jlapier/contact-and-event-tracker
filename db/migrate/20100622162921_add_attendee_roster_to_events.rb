class AddAttendeeRosterToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :attendee_roster, :text
  end

  def self.down
    remove_column :events, :attendee_roster
  end
end
