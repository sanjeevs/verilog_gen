require 'spec_helper'

# Check that ports can be added to a verilog module.
# If we want to reuse the ports from existing module then use clone.
#
class Leaf < VerilogGen::HdlModule
  add_port "clk"
end

class Node < VerilogGen::HdlModule; 
  leaf = add_child_instance Leaf, "leaf"
  # Connect port 'clk' of instance 'leaf' to net sclk
  leaf.clk.connect "sclk" 
end


describe VerilogGen::HdlModule do
  it "should have correct pin name using dot notation" do
    expect(Node.leaf.clk.name).to eq("sclk")
  end
  it "should have correct pin name using array notation" do
    expect(Node.leaf.pins["clk"].name).to eq("sclk")
  end
 
  it "should throw exception if pin attribute is not valid"  do
    expect { Node.leaf.clk.connect "name", xxx: 10 }.to raise_exception
  end
end
