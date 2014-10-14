Feature: Connect ports hierarchly. 

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

      module dut(out);
      output[19:0] out;

      wire[19:0] out;

      node1 node1(.out(out[9:0]));
      
      endmodule
    """
  Then the file "node1.v" should contain:
    """

      module node1(out);
      output[19:0] out;

      wire[19:0] out;

      node0 node0(.out(out[9:0]));
      
      endmodule
    """
  Then the file "node0.v" should contain:
    """

      module node0(out);
      output[19:0] out;

      wire[19:0] out;

      leaf leaf(.out(out[9:0]));
      
      endmodule
    """


