Feature: convert a verilog 1364-2001 format to ruby.

  Scenario: Single input port
  Given a file named "leaf.v" with: 
  """
  module leaf (
    input  in,
    output out
  );
  endmodule
  """
  And a file named "expect.rb" with:
  """
  class Leaf < VerilogGen::HdlModule
    set_proxy true
    set_file_name "leaf.v"
    set_module_name "leaf"
    add_port "in", direction: "input", type: "wire"
    add_port "out", direction: "output", type: "wire"
  end
  """
  When I run `csh -c '../../bin/vscan leaf.v > leaf.rb'`
  Then a file named "leaf.rb" should exist 
  When I run `hdl_equal expect.rb leaf.rb`
  Then the exit status should be 0
