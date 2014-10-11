Feature: Tie a child instance port to a fixed value.

Scenario: Tie input port of a child to a constant value.
  Given a file named "leaf.rb" with: 
  """
  class Leaf < HdlModule
    def build_phase
      add_port Port.new("in1", direction: "input", width: 10),
               Port.new("out1", direction: "output"))
    end
  end
  """
  And a file named "dut.rb" with:
  """
  class Dut < HdlModule

    def build_phase
       add_instance Leaf, "leaf1"
    end

    def connect_phase
       tie leaf1.in1 48  #Tied port to a constant value
       connect leaf1.out1, "out" 
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

