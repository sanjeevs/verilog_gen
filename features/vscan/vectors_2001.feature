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
  class Leaf < VerilogGen::HdlModule
    set_proxy true
    set_file_name "leaf.v"
    set_module_name "leaf"
    add_port "in1", direction: "input", packed: "[5:3]", type: "wire"
    add_port "in2", direction: "input", packed: "[7:0]", type: "wire"
    add_port "out1", direction: "output", packed: "[31:0]", type: "wire"
    add_port "out2", direction: "output", packed: "[8:3]", type: "wire"
  end
  """
  When I run `csh -c '../../bin/vscan leaf.v > leaf.rb'`
  Then a file named "leaf.rb" should exist 
  When I run `hdl_equal expect.rb leaf.rb`
  Then the exit status should be 0
