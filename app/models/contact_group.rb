class ContactGroup < ActiveRecord::Base
  has_and_belongs_to_many :contacts

  def drop_contacts(drop_contact_ids)
    drop_contact_ids = [*drop_contact_ids].compact.map(&:to_i)
    self.contact_ids = contact_ids - drop_contact_ids
    self.save
  end
end
