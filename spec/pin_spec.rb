require 'spec_helper'

describe VerilogGen::Pin do
  let(:clk_port) { VerilogGen::Port.new("clk", type: "wire", rhs: 1, lhs: 3) }
  let(:default_pin) { VerilogGen::Pin.new(clk_port) }

  it "should have the name of the port" do
    expect(default_pin.name).to eql("clk") 
  end

  it "should have the type of the port" do
    expect(default_pin.type).to eql("wire")
  end

  it "should have the lhs of the port" do
    expect(default_pin.lhs).to eql(3)
  end
  
  it "should have the rhs of the port" do
    expect(default_pin.rhs).to eql(1)
  end

  it "should have the width of the port" do
    expect(default_pin.width).to eql(3)
  end
  it "should have the direction of the port" do
    expect(default_pin.direction).to eql("input")
  end

  describe "Connect update" do
    it "should update the name" do 
      default_pin.connect("my_clk")
      expect(default_pin.name).to eql("my_clk")
    end

  end
end
