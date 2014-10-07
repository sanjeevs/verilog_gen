Feature: Construct the simplest possible wrapper

  Scenario: connect one leaf
  Given a file named "leaf.rb" with: 
  """
  class Leaf < HdlModule
    @child_instances = []
    @ports = [ Port.new("in1"),
               Port.new("out1", direction: "output") ]
  end
  """
  And a file named "dut.rb" with:
  """
  class Dut < HdlModule
    @child_instances = [Leaf.new("leaf1")]
  end
  """

  When I run `vgen leaf.rb dut.rb `
  Then the file "dut.v" should contain:
    """

      module dut(in1, out1);
      input in1;
      output out1;

      Leaf leaf1(.in1(in1),
                 .out1(out1));

      endmodule
    """
