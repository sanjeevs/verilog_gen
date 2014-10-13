Feature: Regular expression naming
  Replace all the ports with substring "_almost_" to port "_nearly_"
  use capture group to swap the prefix and suffix 

  Scenario: connect one leaf
  Given a file named "leaf.rb" with: 
  """
  class Leaf < HdlModule
    def build
      add_port  "a_almost_b"
      add_port  "c_almost_d"
    end
  end
  """
  And a file named "dut.rb" with:
  """
  class Dut < HdlModule
    def build
       add_instance Leaf, "leaf1"
       leaf1.ports.each do |p|
        p.connect_pin p.name.gsub /(.)_almost_(.)/, "\2_nearly_\1"
       end
    end

  end
  """

  When I run `vgen leaf.rb dut.rb `
  Then the file "dut.v" should contain:
    """

      module dut(b_nearly_a, d_nearly_c);
      input b_nearly_a;
      input d_nearly_c;

      wire b_nearly_a;
      wire d_nearly_c;

      Leaf leaf1(.a_almost_b(b_nearly_a),
                 .c_almost_d(d_nearly_c));

      endmodule
    """
