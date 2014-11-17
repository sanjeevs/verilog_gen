Feature: convert a verilog 1364 format to ruby.

  Scenario: Single input port, no carriage returns in module declaration
  Given a file named "leaf.v" with: 
  """
  module leaf (in, out);
  input in;
  output out;
  endmodule
  """
  And a file named "expect.rb" with:
  """
  class Leaf < HdlModule
    def initialize
      proxy = true
      file_name = "leaf.v"
      module_name = "leaf"
      add_port "in", direction: "input"
      add_port "out", direction: "output"
    end
  end
  """
  When I run `vscan leaf.v`
  Then a file named "leaf.rb" should exist 
  When I run `hdl_equal expect.rb leaf.rb`
  Then the exit status should be 0
