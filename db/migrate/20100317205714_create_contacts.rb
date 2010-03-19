class CreateContacts < ActiveRecord::Migration
  def self.up
    create_table :contacts do |t|
      %w( first_name
          last_name
          title
          division
          agency
          city
          state
          zip
          agency_phone
          direct_phone
          alternate_phone
          fax_phone
          email
          website	).each do |str_field|
        t.string str_field.to_sym                  
      end
      
      %w( street_address
          comments
          descriptors
          home_address	).each do |text_field|
        t.text text_field.to_sym                  
      end
                              
      t.timestamps
    end

    add_column :users, :contact_id, :integer
  end

  def self.down
    drop_table :contacts
  end
end
