# User.roles = {
#   :admin => {
#     :allowed => :all
#   },
#   :editor => {
#     :allowed => {
#       :create => ['events', 'contacts', 'contact_groups'],
#       :update => ['events', 'contacts', 'contact_groups'],
#       :view => :all,
#       :destroy => :none,
#       :show_email => :all
#     }
#   },
#   :general => {
#     :allowed => {
#       :view => [:events, :contacts],
#       :create => :none,
#       :update => :none,
#       :destroy => :none,
#       :show_email => :all
#     }
#   }
# }
class AccessPolicy
  cattr_reader :writable_regex, :viewable_regex, :deletable_regex
  
  ROLES = User.roles
  
  @@writable_regex = /^(create|update|edit|new|add_members|drop_contact|add_contacts|add_attendees|write)$/i
  @@viewable_regex = /^(index|show|view|emails)$/i
  @@deletable_regex = /^(delete|destroy$)/i
  
  def self.these_match?(this_one, this_two)
    this_one.to_s.downcase == this_two.to_s.downcase
  end
  
  def self.allows?(role, operation, target)
    return false unless ROLES.has_key?(role.to_s.downcase.to_sym)
    
    operation = :view if operation.to_s =~ @@viewable_regex
    operation = :write if operation.to_s =~ @@writable_regex
    operation = :delete if operation.to_s =~ @@deletable_regex
    
    return ROLES.detect do |r, p|
      
      these_match?(r, role) &&
      role_granted_privilege?(p, operation, target)
      
    end || false
  end
  
  def self.role_granted_privilege?(privileges, operation, target)
    return false unless privileges.has_key?(:allowed)
    return false if privileges[:allowed] == :none
    return true if privileges[:allowed] == :all
    
    return privileges[:allowed].detect do |o, ts|
      these_match?(o, operation) &&
      allowed_operation_includes_target?(target, ts)
    end || false
  end
  
  def self.allowed_operation_includes_target?(target, targets)
    return false if targets == :none
    return true if targets == :all
    
    if targets.kind_of?(Array)
      
      return targets.detect do |t|
        these_match?(target, t)
      end || false
      
    end
  end
  
end