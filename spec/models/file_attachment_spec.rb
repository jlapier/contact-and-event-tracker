require 'spec_helper'

describe FileAttachment do
  before(:each) do
    @valid_attributes = {
      :name => "value for name",
      :description => "value for description",
      :filepath => "value for filepath",
      :event_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    FileAttachment.create!(@valid_attributes)
  end
end
