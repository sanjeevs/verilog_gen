Feature: Rename the input and output pins

  Scenario: connect one leaf
  Given a file named "leaf.rb" with: 
  """
  class Leaf < HdlModule
    def build
      add_port Port.new("in1"),
               Port.new("out1", direction: "output"))
    end
  end
  """
  And a file named "dut.rb" with:
  """
  class Dut < HdlModule

    def build_instances
       add_instance Leaf, "leaf1"

    end

    def connect_pins
       #Create the pin
       connect leaf1.in1, "in" 
       connect leaf1.out1, "out" 
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
