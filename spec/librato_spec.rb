require 'spec_helper'
Dir[File.join(File.expand_path("../../lib/chef/*.rb", __FILE__))].each { |f| require f }

testoptions = {
  :source => "test",
  :email => "test@test.com",
  :api_key => "asdfg"
}

librato = LibratoReporting.new testoptions

describe LibratoReporting do

  it "Source should return a valid name" do
    expect(librato.source).to eq('test')
  end

  it "Email should return a valid email address" do
    expect(librato.email).to eq('test@test.com')
  end

  it "API Key should return something" do
    expect(librato.api_key).to eq('asdfg')
  end
	
end
