class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.string :name
      t.string :event_type
      t.date :start_on
      t.date :end_on
      t.text :location
      t.text :description

      t.timestamps
    end
    
    create_table :contacts_events, :id => false do |t|
      t.integer :contact_id
      t.integer :event_id
    end
  end

  def self.down
    drop_table :events
  end
end
