require 'spec_helper'

module HdlHierSpec
  # Check that ports can be added to a verilog module.
  # If we want to reuse the ports from existing module then use clone.
  #
  describe VerilogGen::HdlModule do
    before(:all) do
      class Leaf < VerilogGen::HdlModule
        add_port "clk"
      end

      class Node < VerilogGen::HdlModule; 
        leaf = add_child_instance "leaf", Leaf
        # Connect port 'clk' of instance 'leaf' to net sclk
        leaf.clk.connect "sclk" 
      end

      class NewLeaf < VerilogGen::HdlModule
      end

      class SuperNode < VerilogGen::HdlModule
        add_child_instance "node", Node
        add_child_instance "node.leaf.new1", NewLeaf
      end
    end
    it "should have leaf correct pin name using dot notation" do
      expect(Node.leaf.clk.name).to eq("sclk")
    end
    it "should have correct hier pin name using dot notation" do
      expect(SuperNode.node.leaf.clk.name).to eq("sclk")
    end
    it "should have correct pin name using array notation" do
      expect(Node.leaf.pins["clk"].name).to eq("sclk")
    end
    it "should have correct hier pin name using array notation" do
      expect(SuperNode.node.leaf.pins["clk"].name).to eq("sclk")
    end

    it "should throw exception if pin attribute is not valid"  do
      expect { Node.leaf.clk.connect "name", xxx: 10 }.to raise_exception
    end

  end
end
