class OpenIdAuth < ActiveRecord::Migration
  def self.up
    add_column :users, :openid_identifier, :string
    add_index :users, :openid_identifier
    
    create_table :open_id_authentication_associations, :force => true do |t|
      t.integer :issued, :lifetime
      t.string :handle, :assoc_type
      t.binary :server_url, :secret
    end

    create_table :open_id_authentication_nonces, :force => true do |t|
      t.integer :timestamp, :null => false
      t.string :server_url, :null => true
      t.string :salt, :null => false
    end
  end

  def self.down
    remove_column :users, :openid_identifier
    drop_table :open_id_authentication_associations
    drop_table :open_id_authentication_nonces
  end
  
  
end
