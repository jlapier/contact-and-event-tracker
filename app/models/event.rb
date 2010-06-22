# t.string   "name"
# t.string   "event_type"
# t.date     "start_on"
# t.date     "end_on"
# t.text     "location"
# t.text     "description"
# t.datetime "created_at"
# t.datetime "updated_at"
# t.text     "notes"

class Event < ActiveRecord::Base
  has_many :attendees, :before_add => :revise!, :after_remove => :revise!, :conditions => {:revisable_is_current => true}
  has_many :contacts, :through => :attendees, :order => ["last_name, first_name"],
   :before_add => :revise!, :after_remove => :revise!, :conditions => {:revisable_is_current => true}
  
  has_many :file_attachments

  validates_presence_of :name, :event_type, :start_on

  acts_as_stripped :name
  
  acts_as_revisable :revision_class_name => 'EventRevision', :on_destroy => :revise
  
  after_revise :revise_attendees!
  
  private
  
    def revise_attendees!
      self.attendees.each(&:revise!)
    end

    def validate
      if start_on and end_on and start_on > end_on
        errors.add :end_on, "cannot be before the start date"
      end
    end
    
  protected
  public

    class << self
      def existing_event_types
        find(:all, :select => 'DISTINCT event_type').map(&:event_type).reject { |ev| ev.blank? }.sort
      end
    end

    def drop_contacts(drop_contact_ids)
      drop_contact_ids = [*drop_contact_ids].compact.map(&:to_i)
      #self.contact_ids = contact_ids - drop_contact_ids
      self.contacts.delete(self.contacts.find(drop_contact_ids))
      self.save
    end


    def to_s
      "#{name} (#{start_on} #{end_on ? ' - ' + end_on.to_s : ''})"
    end
  
    def to_hash_for_calendar
      { :id => id, :title => name, :start => start_on, :end => end_on, :url => "/events/#{id}", 
        :description => description && description.gsub("\n", "<br/>") || '',
        :location => location && location.gsub("\n", "<br/>") || '' }
    end

    # list all groups that had least one member in attendance at this event
    def contact_groups_represented
      @contact_groups_represented ||= contacts.map(&:contact_groups).flatten.uniq
    end
end
