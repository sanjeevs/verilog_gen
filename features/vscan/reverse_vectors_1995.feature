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
    def build
      add_port "in1", width: 3, direction: "input"
      add_port "in2", width: 8, direction: "input"
      add_port "out1", width: 32, direction: "output"
      add_port "out2", width: 6, direction: "output"
    end
  end
  """
  When I run `vscan leaf.v`
  Then a file named "leaf.rb" should exist 
  When I run `hdl_equal expect.rb leaf.rb`
  Then the exit status should be 0
