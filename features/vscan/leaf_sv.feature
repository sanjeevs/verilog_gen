Feature: convert a system verilog format to ruby.

  Scenario: Single input port
  Given a file named "leaf.sv" with: 
  """
  module leaf (
    input  logic [3:0] in,
    output reg   [2:0] out,
  );
  endmodule
  """
  And a file named "expect.rb" with:
  """
  class Leaf < HdlModule
    def initialize
      proxy = true
      file_name = "leaf.v"
      module_name = "leaf"
      add_port "in", direction: "input", lhs: 3, rhs: 0
      add_port "out", direction: "output", lhs: 2, rhs: 0
      add_port "out_l", direction: "output"
    end
  end
  """
  When I run `vscan leaf.sv`
  Then a file named "leaf.rb" should exist 
  When I run `hdl_equal expect.rb leaf.rb`
  Then the exit status should be 0
