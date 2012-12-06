require 'spec_helper'
require 'robe'

describe Robe do
  before do
    $stderr = File.new(IO::NULL, "w")
    Robe.start(12345)
  end

  after do
    Robe.stop if Robe.server
    $stderr = STDERR
  end

  it "has a server attribute" do
    expect(Robe.server).to be_a(Robe::Server)
  end

  it "has a stop method" do
    expect { Robe.stop }.to stop_it
  end

  %w(INT TERM).each do |signal|
    it "shuts down on #{signal}" do
      expect { Process.kill(signal, Process.pid) }.to stop_it
    end
  end

  RSpec::Matchers.define :stop_it do
    match do |proc|
      server = Robe.server
      proc.call
      Robe.server.nil? && server.status == :Stop
    end
  end
end
