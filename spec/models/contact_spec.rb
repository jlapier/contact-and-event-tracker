require 'spec_helper'

describe Contact do
  before(:each) do
    @valid_attributes = {
      :first_name => "Joe", :last_name => "Camel"
    }
  end

  it "should create a new instance given valid attributes" do
    Contact.create!(@valid_attributes)
  end

  describe "distinct attribute finders" do
    before(:each) do
      Contact.create! :first_name => "blanky"
      Contact.create! :state => "NY", :agency => "",                :division => "HR"
      Contact.create! :state => "NY", :agency => "Dept of Ed",      :division => ""
      Contact.create! :state => "OR", :agency => "Dept of Ed",      :division => "Spec Ed"
      Contact.create! :state => "",   :agency => "Dept of Spec Ed", :division => "HR"
    end

    it "should find states" do
      Contact.existing_states.should == ["NY", "OR"]
    end

    it "should find agencies" do
      Contact.existing_agencies.should == ["Dept of Ed", "Dept of Spec Ed"]
    end

    it "should find divisions" do
      Contact.existing_divisions.should == ["HR", "Spec Ed"]
    end
  end
  
  it "should create a new version when an attribute is updated" do
    contact = Contact.create!(@valid_attributes)
    contact.first_name = 'Sally'
    contact.revision_number.should == 0
    contact.save
    contact.revision_number.should == 1
  end
  
  it "belongs to a user who has modified it" do
    contact = Contact.new
    contact.should respond_to(:modified_by_user)
    contact.should respond_to(:build_modified_by_user)
  end
end
