Feature: A vector port can have multiple sub ranges.

Scenario: Split a vector input port
  Given a file named "leaf.rb" with: 
  """
  class Leaf < HdlModule
    def build
      add_port "in1", direction: "input", width: 10
    end
  end
  """
  And a file named "dut.rb" with:
  """
  class Dut < HdlModule

    def build
       add_instance Leaf, "leaf1"
       leaf1.in1.range(0).connect_pin "i0"
       leaf1.in1.range(3,1).unused
       leaf1.in1.range(9, 4).connect_pin "in"
    end

  end
  """

  When I run `vgen leaf.rb dut.rb `
  Then the file "dut.v" should contain:
    """

      module dut(in0, in1);
      input in0;
      input [5:0] in;

      wire in0;
      wire [5:0] in;
      wire [2:0] leaf1_in1_unused_0;

      Leaf leaf1(.in1({in, leaf1_in1_unused_0[2:0], in0}), 
                 .out1(out));

      endmodule
    """

