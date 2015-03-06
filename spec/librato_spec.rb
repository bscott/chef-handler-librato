require 'spec_helper'
Dir[File.join(File.expand_path("../../lib/chef/*.rb", __FILE__))].each { |f| require f }

describe LibratoReporting do

  it "Metric should return counter" do
    librato = LibratoReporting.new
    librato.metric_type.should.in?(['counter','gauge'])
    librato.email.should == 'test@test.com'
    librato.api_key.should == 'asdfg'
  end

  it "Email should return a valid email address" do
    librato = LibratoReporting.new
    librato.email.should == 'test@test.com'
    librato.api_key.should == 'asdfg'
  end

  it "API Key should return something" do
    librato = LibratoReporting.new
    librato.api_key.should == 'asdfg'
  end
	
end
