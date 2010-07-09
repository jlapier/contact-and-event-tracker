require 'spec_helper'

def privileges
  {
    :admin => {
      :allowed => :all
    },
    :editor => {
      :allowed => {
        :write => [:events, :contacts, :contact_groups, :file_attachments],
        :view => [:events, :contacts, :contact_groups, :file_attachments],
        :destroy => :none,
        :show_email => :all
      }
    },
    :general => {
      :allowed => {
        :view => [:events, :contacts],
        :write => :none,
        :destroy => :none,
        :show_email => :all
      }
    }
  }
end

def non_admin_roles
  ['editor', 'general']
end

describe AccessPolicy do
  
  it "should be able to identify matches given either symbols or strings" do
    AccessPolicy.these_match?(:some_value, 'some_value').should be_true
    AccessPolicy.these_match?('some_value', :some_value).should be_true
    AccessPolicy.these_match?('some_value', :some_other_value).should be_false
    AccessPolicy.these_match?('some_other_value', :some_value).should be_false
  end
  
  describe "role privileges" do
    
    it "admin is always allowed all privileges" do
      AccessPolicy.allows?('admin', 'to_do', 'anything')
    end
    
    describe "exclusively allows Admin access to Users; " do
      non_admin_roles.each do |role|
        describe "#{role.capitalize} users are prohibited from:" do
          %w(index show create edit update).each do |action|
            it action do
              AccessPolicy.allows?(role, action, 'users').should be_false
            end
          end
        end
      end
    end
    
    describe "prohibit General Users from the following access to" do
      %w(events contacts contact_groups file_attachments).each do |resource|
        describe resource do
          %w(new create edit update delete).each do |action|
            it action do
              AccessPolicy.allows?('general', action, resource).should be_false
            end
          end
        end
      end
    end
    
    %w(editor general).each do |role|
      describe "#{role.to_s.capitalize} allowed" do
        privileges[role.to_sym][:allowed].each do |verb, targets|
          describe "#{verb.to_s.capitalize} (indicates the following actions)" do

            targets.each do |controller|
              describe "for #{controller.to_s.split('_').collect{|c| c.capitalize}.join(' ')}" do
                
                AccessPolicy.writable_regex.to_s.delete('()/^$').gsub(/^\?i-mx:/, '').split('|').flatten.compact.each do |action|
                  unless (
                    (
                      controller != :contact_groups &&
                      action =~ /(add_members|drop_contact|add_contacts|emails)/
                    ) || (
                      controller != :events &&
                      action =~ /(add_attendees)/
                    )
                  )
                    it action do
                      AccessPolicy.allows?(role, action, controller).should be_true
                    end
                  end
                end if verb.to_s =~ AccessPolicy.writable_regex
                
                AccessPolicy.viewable_regex.to_s.delete('()/^$').gsub(/^\?i-mx:/, '').split('|').flatten.compact.each do |action|
                  unless (
                    (
                      controller != :contact_groups &&
                      action =~ /(add_members|drop_contact|add_contacts|emails)/
                    ) || (
                      controller != :events &&
                      action =~ /(add_attendees)/
                    )
                  )
                    it action do
                      AccessPolicy.allows?(role, action, controller).should be_true
                    end
                  end
                end if verb.to_s =~ AccessPolicy.viewable_regex
                
                AccessPolicy.deletable_regex.to_s.delete('()/^$').gsub(/^\?i-mx:/, '').split('|').flatten.compact.each do |action|
                  unless (
                    (
                      controller != :contact_groups &&
                      action =~ /(add_members|drop_contact|add_contacts|emails)/
                    ) || (
                      controller != :events &&
                      action =~ /(add_attendees)/
                    )
                  )
                    it action do
                      AccessPolicy.allows?(role, action, controller).should be_true
                    end
                  end
                end if verb.to_s =~ AccessPolicy.deletable_regex
              end # end describe "for #{controller.to_s.split('_')...}"
            end if targets.kind_of?(Array)
            
            case targets
            when :all || 'all'
              it "#{verb} access for all resources" do
                AccessPolicy.allows?(role, verb, 'all').should be_true
              end
            when :none || 'none'
              it "denied #{verb} access from any resources" do
                AccessPolicy.allows?(role, verb, 'any').should be_false
              end
            else
              it "#{targets} is unknown: all and none are the only valid options if controller names aren't passed in an Array" do
                (targets.to_s =~ /(all|none)/).should be_true
              end
            end if targets.kind_of?(Symbol)
          end
        end
      end
    end
  end
end