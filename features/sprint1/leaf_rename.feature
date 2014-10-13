Feature: Rename the input and output pins

  Scenario: connect one leaf
  Given a file named "leaf.rb" with: 
  """
  class Leaf < HdlModule
    def build
      add_port "in1"
      add_port "out1", direction: "output"
    end
  end
  """
  And a file named "dut.rb" with:
  """
  class Dut < HdlModule

    def build
       add_instance Leaf, "leaf1"
       connect_port_to_pin leaf1.in1, "in" 
       connect_port_to_pin leaf1.out1, "out" 
    end

  end
  """

  When I run `vgen leaf.rb dut.rb `
  Then the file "dut.v" should contain:
    """

      module dut(in, out);
      input in;
      output out;

      wire in;
      wire out;

      Leaf leaf1(.in1(in),
                 .out1(out));

      endmodule
    """
