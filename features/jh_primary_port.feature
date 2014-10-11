Feature: Inhibit a pin from appearing as primary i/o.

Scenario: inhibit a input from appearing as primary input
  Given a file named "leaf.rb" with: 
  """
  class Leaf < HdlModule
    def build_phase
      add_port Port.new("in1"),
               Port.new("out1", direction: "output"))
    end
  end
  """
  And a file named "dut.rb" with:
  """
  class Dut < HdlModule

    def build_phase
       add_instance Leaf, "leaf1"
       skip_port_name "in"
    end

    def connect_phase
       #Create the pin
       connect leaf1.in1, "in" 
       connect leaf1.out1, "out" 
    end

  end
  """

  When I run `vgen leaf.rb dut.rb `
  Then the file "dut.v" should contain:
    """

      module dut(out);
      output out;

      wire in;
      wire out;

      Leaf leaf1(.in1(in),
                 .out1(out));

      endmodule
    """

Scenario: create a unconnected primary output port
  Given a file named "leaf.rb" with: 
  """
  class Leaf < HdlModule
    def build_phase
      add_port Port.new("in1"),
               Port.new("out1", direction: "output"))
    end
  end
  """
  And a file named "dut.rb" with:
  """
  class Dut < HdlModule

    def build_phase
       add_instance Leaf, "leaf1"
       skip_port_name "in"
       add_port Port.new("dummy", direction: "output", width: 10)
    end

    def connect_phase
       #Create the pin
       connect leaf1.in1, "in" 
       connect leaf1.out1, "out" 
    end

  end
  """

  When I run `vgen leaf.rb dut.rb `
  Then the file "dut.v" should contain:
    """

      module dut(out, dummy);
      output out;
      output [9:0] dummy;

      wire in;
      wire out;

      Leaf leaf1(.in1(in),
                 .out1(out));

      endmodule
    """
