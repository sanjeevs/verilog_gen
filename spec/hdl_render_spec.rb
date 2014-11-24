require 'spec_helper'

# Render the ruby code to verilog.
#
class Leaf < VerilogGen::HdlModule
  set_module_name "leaf"
  add_port "clk"
end

class Node < VerilogGen::HdlModule; 
  leaf = add_child_instance Leaf, "leaf"
  # Connect port 'clk' of instance 'leaf' to net sclk
  leaf.clk.connect "sclk" 
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

  Leaf leaf(
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
