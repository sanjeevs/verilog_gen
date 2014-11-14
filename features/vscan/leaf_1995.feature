Feature: convert a verilog 1364 format to ruby.

  Scenario: Single input port
  Given a file named "leaf.v" with: 
  """
  module leaf(in, out);
    input in;
    output out;
  endmodule
  """
  And a file named "expect.rb" with:
  """
  class Leaf < HdlModule
    def build
      add_port "in", width: 1, direction: "input"
      add_port "out", width: 1, direction: "output"
    end
  end
  """
  When I run `vscan leaf.v`
  Then the file 'leaf.rb' should exist 
  And when I run `hdl_equal expect.rb leaf.rb'
  Then the exit status should be 0
