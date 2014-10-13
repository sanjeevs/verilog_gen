Feature: Tie a child instance port to a fixed value.

Scenario: Tie input port of a child to a constant value.
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
       leaf1.in1.tie_to(48)  #Tied port to a constant value
       leaf1.out1.connect_pin "out" 
    end

  end
  """

  When I run `vgen leaf.rb dut.rb `
  Then the file "dut.v" should contain:
    """

      module dut(out);
      output out;

      wire out;

      Leaf leaf1(.in1(10'd48),
                 .out1(out));

      endmodule
    """

