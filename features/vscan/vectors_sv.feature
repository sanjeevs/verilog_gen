Feature: convert a verilog 1364-2001 format to ruby.

  Scenario: Vectored ports
  Given a file named "leaf.sv" with: 
  """
  module leaf (
    input  logic [5:3]       in1,
    input  logic [7:0]       in2   [31:7],
    input  wire              in3   [3:0],
    output reg   [31:0]      out1  [7:0] [5:0] [2:0],
    output reg   [8:3] [2:0] out2  [1:0]
  );
  endmodule
  """
  And a file named "expect.rb" with:
  """
  class Leaf < VerilogGen::HdlModule
    set_proxy true
    set_file_name  "leaf.sv"
    set_module_name "leaf"
    add_port "in1", direction: "input", type: "logic", packed: "[5:3]"
    add_port "in2", direction: "input", type: "logic", packed: "[7:0]", unpacked: "[31:7]"
    add_port "in3", direction: "input", type: "wire", unpacked: "[3:0]"
    add_port "out1", direction: "output", type: "reg", packed: "[31:0]", unpacked: "[7:0][5:0][2:0]"
    add_port "out2", direction: "output", type: "reg", packed: "[8:3][2:0]", unpacked: "[1:0]"
  end
  """
  When I run `csh -c '../../bin/vscan leaf.sv > leaf.rb'`
  Then a file named "leaf.rb" should exist 
  When I run `hdl_equal expect.rb leaf.rb`
  Then the exit status should be 0
