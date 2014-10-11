Feature: Regular expression naming
  Replace all the ports with substring "_almost_" to port "_nearly_"
 

  Scenario: connect one leaf
  Given a file named "leaf.rb" with: 
  """
  class Leaf < HdlModule
    def build
      add_port  Port.new("a_almost_b"),
                Port.new("c_almost_d"))
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
       leaf.ports.each do |port|
        connect port, port.name.gsub /_almost_/, "_nearly_"
       end
    end

  end
  """

  When I run `vgen leaf.rb dut.rb `
  Then the file "dut.v" should contain:
    """

      module dut(a_nearly_b, c_nearly_d);
      input a_nearly_b;
      input c_nearly_d;

      wire a_nearly_b;
      wire c_nearly_d;

      Leaf leaf1(.a_almost_b(a_nearly_b),
                 .c_almost_d(c_nearly_d));

      endmodule
    """
