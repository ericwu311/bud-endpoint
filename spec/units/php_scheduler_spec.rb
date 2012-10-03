require 'spec_helper'

describe "PhpScheduler" do 
  it "should enqueue PhpCmd to run rightaway if first time" do 
    Resque.should_receive(:enqueue).with(PhpCmd, "foo", {:num_of_tries => 1})
    PhpScheduler.schedule("foo")
  end

  it "should enqueue Phpcmd to run in 5 seconds after first time" do 
    1.upto(5) do |i|
      Resque.should_receive(:enqueue_in).with(5.seconds, PhpCmd, "foo", {:num_of_tries => i+1})
      PhpScheduler.schedule("foo", :num_of_tries => i)
    end
  end

  it "should give up after 5th time" do 
    Resque.should_not_receive(:enqueue_at)
    Resque.should_not_receive(:enqueue)
    expect { PhpScheduler.schedule("foo", :num_of_tries => 6) }.to raise_error PhpScheduler::GiveUpException
  end

end