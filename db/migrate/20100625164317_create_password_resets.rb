class CreatePasswordResets < ActiveRecord::Migration
  def self.up
    create_table :password_resets do |t|
      t.integer :user_id
      t.string :status, :limit => 100
      t.string :requesting_ip, :limit => 30
      t.string :confirming_ip, :limit => 30
      t.string :sent_to

      t.timestamps
    end
  end

  def self.down
    drop_table :password_resets
  end
end
