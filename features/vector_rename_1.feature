Feature: Rename a vector port to separate pins

  Scenario: connect one leaf
  Given a file named "leaf.rb" with: 
  """
  class Leaf < HdlModule
    def build
      add( Port.new("in1", width: 10),
           Port.new("out1", direction: "output", width: 5))
    end
  end
  """
  And a file named "dut.rb" with:
  """
  class Dut < HdlModule
    def build
       l = add(Leaf.new("leaf1"))
       l.ports["in1"].width(5,0).connect_pin("sub_in1")
       l.ports["in1"].width(9,6).connect_pin("sub_in2")
       l.ports["out1"].connect_pin("out")
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
