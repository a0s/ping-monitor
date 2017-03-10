require File.dirname(__FILE__) + '/spec_helper'

describe "spec1" do

  it "app name should be" do
    App.name.should == "pingmon"
  end

end