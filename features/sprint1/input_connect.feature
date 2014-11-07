Feature: algorithms for input pins to become primary inputs.

  Scenario: Multiple inputs with the same width
  Given a file named "leaf.rb" with: 
  """
  class Leaf < HdlModule
    def build
      add_port "in1", width: 10
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
  When I run `vgen leaf.rb dut.rb --top Dut`
  Then the file "dut.v" should contain:
    """

      module dut(in1);
      input[9:0] in1;

      wire[9:0] in1;

      Leaf leaf1(.in1(in1));
      Leaf leaf2(.in1(in1));

      endmodule
    """

  Scenario: Multiple inputs with different width
  Given a file named "leaf1.rb" with: 
  """
  class Leaf1 < HdlModule
    def build
      add_port "in1", width: 10
    end
  end
  """
  Given a file named "leaf2.rb" with: 
  """
  class Leaf2 < HdlModule
    def build
      add_port "in1", width: 16
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
      input[15:0] in1;

      wire[15:0] in1;

      Leaf leaf1(.in1(in1[9:0]));
      Leaf leaf2(.in1(in1[15:0]));

      endmodule
    """
