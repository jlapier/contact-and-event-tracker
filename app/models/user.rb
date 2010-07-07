class User < ActiveRecord::Base
  has_many :password_resets, :order => 'created_at DESC', :dependent => :destroy
  belongs_to :contact
  before_create :make_admin_if_first_user
  after_create :create_contact

  acts_as_authentic do |c|
    c.validate_email_field = false
    c.openid_optional_fields = [:fullname, :email, "http://axschema.org/contant/email"]
  end

  class << self
    def find_by_openid_identifier(identifier)
      first(:conditions => { :openid_identifier => identifier }) ||
        new(:openid_identifier => identifier)
    end
  end

  def map_openid_registration(sreg)
    self.email = sreg["email"] if email.blank?
    self.name  = sreg["fullname"] if name.blank?
  end
  
  def confirm_password_reset
    reset_perishable_token!
    Notification.deliver_password_reset_confirmation(self)
  end
  
  def password_reset_confirmed(confirming_ip)
    return false if password_resets.empty?
    # ok to just confirm first in collection due to :order set in has_many
    password_resets.first.confirm(confirming_ip)
  end
  
  def name_or_contact_name
    name || 
    contact_id && contact.name != ', ' && "#{contact.first_name} #{contact.last_name}" || 
    'unknown'
  end

  private
    def create_contact
      Contact.create! :user => self
    end
  
    def make_admin_if_first_user
      self.is_admin = true if User.count == 0
    end
end
