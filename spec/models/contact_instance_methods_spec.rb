require 'spec_helper'
require 'acts_as_fu'
Spec::Runner.configure do |config|
  config.include ActsAsFu
end

describe ContactInstanceMethods do
  before(:each) do
    build_model :fake_contact do
      ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations[RAILS_ENV.to_sym])
      string :first_name
      string :last_name
      string :agency
      string :division
      
      include ContactInstanceMethods
    end
    @fake_contact = FakeContact.new({
      :first_name => 'Moniker',
      :last_name => 'Sir',
      :agency => 'AFPATGAS',
      :division => '34th Flying Trapezoids'
    })
  end
  it "combines last_name, first_name as name" do
    @fake_contact.name.should == "Sir, Moniker"
  end
  it "aliases name as fullname" do
    @fake_contact.fullname.should == "Sir, Moniker"
  end
  describe "intelligently combining agency and division" do
    it "uses division alone, with no agency" do
      @fake_contact.agency = nil
      @fake_contact.agency_and_division.should == "34th Flying Trapezoids"
    end
    it "uses agency alone, with no division" do
      @fake_contact.division = nil
      @fake_contact.agency_and_division.should == "AFPATGAS"
    end
    it "uses agency and division when possible" do
      @fake_contact.agency_and_division.should == "AFPATGAS; 34th Flying Trapezoids"
    end
    it "allows for custom separators" do
      @fake_contact.agency_and_division(" <> ").should == "AFPATGAS <> 34th Flying Trapezoids"
    end
  end
end
