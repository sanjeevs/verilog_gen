Feature: Swap the leaf module with vendor model. 
Vendor model is backward port comptabible but has extra test ports.

  Scenario: Swap generic leaf with vendor leaf model.
  Given a file named "leaf.rb" with: 
  """
  class Leaf < HdlModule
    def build
      add_port "out", width: 10, direction: "output"
    end
  end
  """
  And a file named "vendor_leaf.rb" with: 
  """
  class VendorLeaf < HdlModule
    def build
      add_port "out", width: 10, direction: "output"
      add_port "test_out", width: 3, direction: "output"
      add_port "test_in"
    end
  end
  """
  And a file named "node0.rb" with:
  """
  class Node0 < HdlModule

    def build
       add_instance Leaf, "leaf"
    end

  end
  """
  And a file named "node1.rb" with:
  """
  class Node1 < HdlModule

    def build
       add_instance Node0, "node0"
    end

  end
  """
  And a file named "dut.rb" with:
  """
  class Dut < HdlModule

    def build
       add_instance Node1, "node1"
    end

  end
  """
  And a file named "vendor_dut.rb" with:
  """
  class VendorDut < Dut 

    def build
      super.build
      swap_instance node1.node0.leaf, VendorLeaf
      node1.node0.leaf.test_in.range(0).tie_to 0
    end

  end
  """

  When I run `vgen --top VendorDut leaf.rb node0.rb node1.rb dut.rb vendor_leaf.rb vendor_dut.rb `
  Then the file "vendor_dut.v" should contain:
    """

      module vendor_dut(out, test_out, test_in);
      output [19:0] out;
      output [1:0] test_out;
      input test_in;

      wire[19:0] out;
      wire [1:0] test_out;
      wire test_in;

      node1 node1(.out(out[9:0]),
                  .test_out(test_out[1:0]), 
                  .test_in(test_in));
      
      endmodule
    """
  Then the file "node1.v" should contain:
    """

      module node1(out, test_out, test_in);
      output [19:0] out;
      output [1:0] test_out;
      input test_in;

      wire[19:0] out;
      wire [1:0] test_out;
      wire test_in;

      node0 node0(.out(out[9:0]),
                  .test_out(test_out[1:0]),
                  .test_in(test_in));
      
      endmodule
    """
  Then the file "node0.v" should contain:
    """

      module node0(out);
      output[19:0] out;
      input [1:0] test_out;
      input test_in;

      wire[19:0] out;
      wire [1:0] test_out;
      wire test_in;

      vendor_leaf leaf(.out(out[9:0]),
                       .test_out({test_out[1:0], 1'b0}),
                       .test_in(test_in));
      
      endmodule
    """


