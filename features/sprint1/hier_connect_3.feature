Feature: Connect ports from intermediate level of hierarchy.

  Scenario: Unconnected leaf ports
  Given a file named "leaf.rb" with: 
  """
  class Leaf < HdlModule
    def build
      add_port "out", width: 10, direction: "output"
    end
  end
  """
  And a file named "node0.rb" with:
  """
  class Node0 < HdlModule

    def build
       add_instance Leaf, "leaf"
       add_port "in"
    end

  end
  """
  And a file named "node1.rb" with:
  """
  class Node1 < HdlModule

    def build
       add_instance Node0, "node0"
    end

  end
  """
  And a file named "dut.rb" with:
  """
  class Dut < HdlModule

    def build
       add_instance Node1, "node1"
    end

  end
  """

  When I run `vgen leaf.rb node0.rb node1.rb dut.rb `
  Then the file "dut.v" should contain:
    """

      module dut(out, in);
      output[19:0] out;
      input in;

      wire[19:0] out;
      wire in;

      node1 node1(.out(out[9:0]), 
                  .in(in));
      
      endmodule
    """
  Then the file "node1.v" should contain:
    """

      module node1(out);
      output[19:0] out;
      input in;

      wire[19:0] out;
      wire in;

      node0 node0(.out(out[9:0]),
                  .in(in));
      
      endmodule
    """
  Then the file "node0.v" should contain:
    """

      module node0(out);
      output[19:0] out;
      input in;

      wire[19:0] out;
      wire in;

      leaf leaf(.out(out[9:0]));
      
      endmodule
    """


