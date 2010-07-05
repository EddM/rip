Dir["#{File.dirname(__FILE__)}/../lib/*.rb"].each { |file| require file }
require 'spec_helper'

describe String do
  
  it "pads a binary string to a given length" do
    "1010".pad_binary_string(8).should == "00001010"
  end
  
  it "should not pad if length exceeds padding" do
    bin = "11101011010"
    lambda { bin.pad_binary_string(8) }.should_not change { bin }
  end
  
end

describe IPAddress do

  it "defaults to 0.0.0.0" do
    IPAddress.new.to_a.should == ['00000000','00000000','00000000','00000000']
  end
  
  it "splits an IP address string into binary digits" do
    @addr = IPAddress.new('192.168.0.1')
    @addr.to_a.should == ['11000000','10101000','00000000','00000001']
  end

  it "turns into a full binary word" do
    @addr = IPAddress.new('192.168.0.1')
    @addr.to_bin.size.should == 32
    @addr.to_bin.should == "11000000101010000000000000000001"
  end
  
  it "doesn't allow octets over 255" do
    IPAddress.new('123.456.123.789').segments.should == [123, 255, 123, 255]
  end
  
  it "doesn't allow octets below 0" do
    IPAddress.new('-5.123.-267.-100').segments.should == [0, 123, 0, 0]
  end
  
  it "pads incomplete ip addresses with '0'" do
    IPAddress.new('192.168').segments.should == [192, 168, 0, 0]
  end
  
  it "truncates long IP addresses" do
    IPAddress.new('192.168.127.75.0.123').segments.should == [192, 168, 127, 75]
  end
  
end

describe IPAddressMask do

  before(:all) do
    @mask = IPAddressMask.new('127.0.0.1/32')
  end

  it "defaults to 0.0.0.0/0" do
    IPAddressMask.new.to_a.should == [0, 0, 0, 0, 0]
  end
  
  it "splits a cidr mask" do
    @mask.to_a.should == [127, 0, 0, 1, 32]
  end
  
  it "isolates the mask digit" do
    @mask.mask.should == 32
  end

  it "doesn't allow octets over 255" do
    IPAddressMask.new('123.456.123.789/16').segments.should == [123, 255, 123, 255]
  end
  
  it "doesn't allow octets below 0" do
    IPAddressMask.new('-5.123.-267.-100/8').segments.should == [0, 123, 0, 0]
  end
  
  it "doesn't allow a mask greater than 32" do
    IPAddressMask.new('127.0.0.1/64').mask.should == 32
  end
  
  it "doesn't allow a mask less than 0" do
    IPAddressMask.new('127.0.0.1/-8').mask.should == 0
  end
  
  it "pads incomplete ip addresses with '0'" do
    @mask = IPAddressMask.new('192.168/16')
    @mask.segments.should == [192, 168, 0, 0]
    @mask.mask.should == 16
  end
  
  it "truncates long IP addresses" do
    @mask = IPAddressMask.new('192.168.127.75.0.123/9')
    @mask.segments.should == [192, 168, 127, 75]
    @mask.mask.should == 9
  end
  
  it "defaults mask digit to '0' if not provided" do
    IPAddressMask.new('192.168').mask.should == 0
  end
  
  it "defaults address octets to 0.0.0.0 if not provided" do
    @mask = IPAddressMask.new('/16')
    @mask.segments.should == [0, 0, 0, 0]
    @mask.mask.should == 16
  end
  
end

describe "CIDR IP address matcher" do
  
  before(:all) do
    @addr = IPAddress.new('192.168.0.1')
  end
  
  it "matches an IP address with it's mask" do
    @addr.should match_cidr_mask('192.168.0.0/8')
    @addr.should match_cidr_mask('192.168.0.0/16')
  end
  
  it "does not match an IP address with a mask it doesn't belong to" do
    @addr.should_not match_cidr_mask('192.168.100.0/24')
    @addr.should_not match_cidr_mask('126.4.100.0/8')
  end
  
  it "matches an ip address to it's full address mask" do
    @addr = IPAddress.new('192.168.1.1')
    @addr.should match_cidr_mask('192.168.1.1/32')
  end
  
  it "matches any ip address to a empty address mask" do
    @addr.should match_cidr_mask('44.44.44.44/0')
  end
  
end