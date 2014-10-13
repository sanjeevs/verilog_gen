Feature: Inhibit a pin from appearing as port

  Scenario: inhibit matching port
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
       leaf1.in1.connect_pin "in" 
       leaf1.out1.connect_pin "out" 
       skip_matching_port(/^out$/)
    end

  end
  """

  When I run `vgen leaf.rb dut.rb `
  Then the file "dut.v" should contain:
    """

      module dut(in);
      input in;

      wire in;
      wire out;

      Leaf leaf1(.in1(in),
                 .out1(out));

      endmodule
    """
