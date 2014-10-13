Feature: algorithms for output pins to become output ports.

  Scenario: Multiple outputs with the same width
  Given a file named "leaf.rb" with: 
  """
  class Leaf < HdlModule
    def build
      add_port "out1", width: 10, direction: "output"
    end
  end
  """
  And a file named "dut.rb" with:
  """
  class Dut < HdlModule

    def build
       add_instance Leaf, "leaf1"
       add_instance Leaf, "leaf2"
    end

  end
  """
  When I run `vgen leaf.rb dut.rb `
  Then the file "dut.v" should contain:
    """

      module dut(out1);
      output[19:0] out1;

      wire[19:0] out1;

      Leaf leaf1(.out1(out1[9:0]));
      Leaf leaf2(.out1(out1[19:10]);

      endmodule
    """

  Scenario: Multiple outputs with different width
  Given a file named "leaf1.rb" with: 
  """
  class Leaf1 < HdlModule
    def build
      add_port "in1", width: 10, direction: "output"
    end
  end
  """
  Given a file named "leaf2.rb" with: 
  """
  class Leaf2 < HdlModule
    def build
      add_port "out1", width: 16
    end
  end
  """
  And a file named "dut.rb" with:
  """
  class Dut < HdlModule

    def build
       add_instance Leaf1, "leaf1"
       add_instance Leaf2, "leaf2"
    end

  end
  """
  When I run `vgen leaf1.rb leaf2.rb dut.rb `
  Then the file "dut.v" should contain:
    """

      module dut(in1);
      output[25:0] in1;

      wire[25:0] out1;

      Leaf leaf1(.out1(out1[9:0]));
      Leaf leaf2(.out1(out1[25:10]));

      endmodule
    """
