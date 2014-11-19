Feature: convert a verilog 1364 format to ruby.

  Scenario: Reversed vectored ports
  Given a file named "leaf.v" with: 
  """
  module leaf (
    in1,
    in2,
    out1,
    out2
  );
  input  [3:5]  in1;
  input  [0:7]  in2;
  output [0:31] out1;
  output [3:8]  out2;
  endmodule
  """
  And a file named "expect.rb" with:
  """
  class Leaf < HdlModule
    def initialize
      proxy = true
      file_name = "leaf.v"
      module_name = "leaf"
      add_port "in1", direction: "input", packed: "[3:5]", type: "wire"
      add_port "in2", direction: "input", packed: "[0:7]", type: "wire"
      add_port "out1", direction: "output", packed: "[0:31]", type: "wire"
      add_port "out2", direction: "output", packed: "[3:8]", type: "wire"
    end
  end
  """
  When I run `vscan leaf.v`
  Then a file named "leaf.rb" should exist 
  When I run `hdl_equal expect.rb leaf.rb`
  Then the exit status should be 0
