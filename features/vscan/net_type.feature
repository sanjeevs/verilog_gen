Feature: convert a verilog 1364-2001 format to ruby.

  Scenario: Port list contains inout types
  Given a file named "leaf.v" with: 
  """
  module leaf (
    input reg       i_reg,
    input logic     i_logic,
    input bit       i_bit,
    input byte      i_byte,
    input shortint  i_shortint,
    input int       i_int,
    input longint   i_longint,
    input time      i_time,
    input realtime  i_realtime,
    input shortreal i_shortreal,
    input real      i_real,
    input wand      i_wand,
    input wor       i_wor,
    input tri       i_tri,
    input triand    i_triand,
    input trior     i_trior,
    input tri0      i_tri0,
    input tri1      i_tri1,
    input supply0   i_supply0,
    input supply1   i_supply1,
    input trireg    i_trireg,
    input wire      i_wire,
    input           i_implicit_wire
  );
  endmodule
  """
  And a file named "expect.rb" with:
  """
  class Leaf < VerilogGen::HdlModule
    set_proxy true
    set_file_name  "leaf.v"
    set_module_name  "leaf"
    add_port "i_reg", direction: "input", type: "reg"
    add_port "i_logic", direction: "input", type: "logic"
    add_port "i_bit", direction: "input", type: "bit"
    add_port "i_byte", direction: "input", type: "byte"
    add_port "i_shortint", direction: "input", type: "shortint"
    add_port "i_int", direction: "input", type: "int"
    add_port "i_longint", direction: "input", type: "longint"
    add_port "i_time", direction: "input", type: "time"
    add_port "i_realtime", direction: "input", type: "realtime"
    add_port "i_shortreal", direction: "input", type: "shortreal"
    add_port "i_real", direction: "input", type: "real"
    add_port "i_wand", direction: "input", type: "wire"
    add_port "i_wor", direction: "input", type: "wire"
    add_port "i_tri", direction: "input", type: "wire"
    add_port "i_triand", direction: "input", type: "wire"
    add_port "i_trior", direction: "input", type: "wire"
    add_port "i_tri0", direction: "input", type: "wire"
    add_port "i_tri1", direction: "input", type: "wire"
    add_port "i_supply0", direction: "input", type: "wire"
    add_port "i_supply1", direction: "input", type: "wire"
    add_port "i_trireg", direction: "input", type: "wire"
    add_port "i_wire", direction: "input", type: "wire"
    add_port "i_implicit_wire", direction: "input", type: "wire"
  end
  """
  When I run `csh -c '../../bin/vscan leaf.v > leaf.rb'`
  Then a file named "leaf.rb" should exist 
  When I run `hdl_equal expect.rb leaf.rb`
  Then the exit status should be 0
