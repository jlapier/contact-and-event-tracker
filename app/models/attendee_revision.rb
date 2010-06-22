class AttendeeRevision < ActiveRecord::Base
  
  acts_as_revision
  
  belongs_to :event, :class_name => 'EventRevision', :autosave => true
  belongs_to :contact, :class_name => 'ContactRevision'
  
  before_create :update_associations, :if => :event_or_contact_in_revision?
  
  before_destroy :update_associations, :if => :event_or_contact_in_revision?
  
  private
    def event_or_contact_in_revision?
      event_in_revision? || contact_in_revision?
    end
    def update_associations
      logger.debug("Updating AttendeeRevision Associations")
      update_event_association if event_in_revision?
      update_contact_association if contact_in_revision?
    end
    def update_event_association
      self.event = self.current_revision.event.find_revision(:previous)
    end
    def event_in_revision?
      self.current_revision.event.in_revision?
    end
    def update_contact_association
      self.contact = self.current_revision.contact.find_revision(:previous)
    end
    def contact_in_revision?
      self.current_revision.contact.in_revision?
    end
  protected
  public  
end