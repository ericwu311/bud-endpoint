require 'spec_helper'

describe "Php Cmd" do 
  it "should do nothing if php cmd success" do 
    PhpCmd.stub(:system).and_return(true)
    PhpScheduler.should_not_receive(:schedule)
    PhpCmd.perform("foo", :num_of_tries => 1)
  end

  it "should call PhpScheduler if php return false" do 
    PhpCmd.stub(:system).and_return(false)
    PhpScheduler.should_receive(:schedule).with("foo", :num_of_tries => 1)
    PhpCmd.perform("foo", :num_of_tries => 1)
  end
end

