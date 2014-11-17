Feature: convert a verilog 1364-2001 format to ruby.

  Scenario: Vectored ports
  Given a file named "leaf.v" with: 
  """
  module leaf (
    input  [5:3]  in1,
    input  [7:0]  in2,
    output [31:0] out1,
    output [8:3]  out2
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
      add_port "in1", direction: "input", lhs: 5, rhs: 3
      add_port "in2", direction: "input", lhs: 7, rhs: 0
      add_port "out1", direction: "output", lhs: 31, rhs: 0
      add_port "out2", direction: "output", lhs: 8, rhs: 3
    end
  end
  """
  When I run `vscan leaf.v`
  Then a file named "leaf.rb" should exist 
  When I run `hdl_equal expect.rb leaf.rb`
  Then the exit status should be 0
