require 'spec_helper'

# Render the ruby code to verilog.
#
class Leaf < VerilogGen::HdlModule
  set_module_name "leaf"
  add_port "clk"
end

class Node < VerilogGen::HdlModule; 
  leaf = add_child_instance "leaf", Leaf
  # Connect port 'clk' of instance 'leaf' to net sclk
  leaf.clk.connect "sclk" 
end

class ParameterLeaf < VerilogGen::HdlModule
  set_module_name "parameter_leaf"
  add_port "clk"
  set_parameter DEPTH: 8
  set_parameter WIDTH: 16 
end

class ParameterNode < VerilogGen::HdlModule; 
  leaf = add_child_instance "parameter_leaf", ParameterLeaf
  # Connect port 'clk' of instance 'leaf' to net sclk
  parameter_leaf.clk.connect "sclk" 
end

describe VerilogGen::HdlModule do
  let(:leaf) { Leaf.new("leaf") }
  let(:leaf_verilog) { """module leaf (
  input wire clk
);

endmodule
"""
  }
  let(:node_verilog) {"""module node (
);

  leaf leaf(
    .clk(sclk)
  );
endmodule
"""
  }
  let(:node) { Node.new("node") }
 
  it { expect(leaf.class.module_name).to eql("leaf") }
  it "should render leaf to verilog" do
    expect(leaf.render).to eql(leaf_verilog)
  end

  it { expect(Node.module_name).to eql("node") }
  it { expect(Node.leaf.pins.size).to eql(1) }

  it "should render node to verilog" do
    expect(node.render).to eql(node_verilog)
  end
end

describe "Parameters" do
  let(:parameter_leaf) { ParameterLeaf.new("leaf") }
  let(:parameter_verilog) { """module parameter_leaf (
  input wire clk
);

endmodule
"""
  }
  let(:node_verilog) {"""module parameter_node (
);

  parameter_leaf #(.DEPTH(8), .WIDTH(16)) parameter_leaf(
    .clk(sclk)
  );
endmodule
"""
  }
  let(:parameter_node) { ParameterNode.new("node") }
 
  it "should render node to verilog" do
    expect(parameter_node.render).to eql(node_verilog)
  end
end
