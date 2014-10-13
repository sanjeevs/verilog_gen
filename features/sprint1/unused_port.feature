Feature: Force a port to be unconnected.

Scenario: Leave a port of a leaf unconnected
  Given a file named "leaf.rb" with: 
  """
  class Leaf < HdlModule
    def build
      add_port "in1", direction: "input", width: 10
      add_port "out1", direction: "output"
    end
  end
  """
  And a file named "dut.rb" with:
  """
  class Dut < HdlModule

    def build
       add_instance Leaf, "leaf1"
       leaf1.in1.unused
       leaf1.out1.connect_pin "out" 
    end

  end
  """

  When I run `vgen leaf.rb dut.rb `
  Then the file "dut.v" should contain:
    """

      module dut(out);
      output out;

      wire [9:0] unused_leaf1_in1
      wire out;

      Leaf leaf1(.in1(unused_leaf1_in1),
                 .out1(out));

      endmodule
    """

