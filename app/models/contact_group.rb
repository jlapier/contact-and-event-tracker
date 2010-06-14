class ContactGroup < ActiveRecord::Base
  has_and_belongs_to_many :contacts, :order => ["last_name, first_name"]

  def drop_contacts(drop_contact_ids)
    drop_contact_ids = [*drop_contact_ids].compact.map(&:to_i)
    self.contact_ids = contact_ids - drop_contact_ids
    self.save
  end

  # list all events that at least one member from this group has attended
  def events_attended_by_members
    @events_attended_by_members ||= contacts.map(&:events).flatten.uniq
  end
end
