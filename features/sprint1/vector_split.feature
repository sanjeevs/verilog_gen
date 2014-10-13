Feature: Rename a vector port to separate pins

  Scenario: connect one leaf
  Given a file named "leaf.rb" with: 
  """
  class Leaf < HdlModule
    def build
      add_port "in1", width: 10
      add_port "out1", direction: "output", width: 5
    end
  end
  """
  And a file named "dut.rb" with:
  """
  class Dut < HdlModule
    def build
      add_instance Leaf "leaf1"
      leaf1.in1.range(5,0).connect_pin("sub_in1")
      leaf1.in1.range(9,6).connect_pin("sub_in2")
      leaf1.out1.connect_pint("out")
    end
  end
  """

  When I run `vgen leaf.rb dut.rb `
  Then the file "dut.v" should contain:
    """

      module dut(in, out);
      input [9:0] in;
      output [4:0] out1;

      wire [5:0] sub_in1;
      wire [3:0] sub_in2;
      wire [4:0] out1;

      Leaf leaf1(.in1({sub_in2, sub_in1}),
                 .out1(out1));

      endmodule
    """
