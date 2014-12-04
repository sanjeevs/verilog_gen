Feature: convert a system verilog format to ruby.
  
  Scenario: More complex port types, note that SV allows all data types
            to be on port lists, including arrays and structures!  This
            test does not test arrays or structures
  Given a file named "leaf.v" with: 
  """
  module leaf (
    output  logic         o_logic_bit,
    output  logic [3:0]   o_logic_vector,
    output  reg           o_reg_bit,
    output  reg  [31:0]   o_reg_vector,
    output  bit           o_bit_bit,
    output  bit [7:0]     o_bit_vector,
    output  byte          o_byte,
    output  shortint      o_shortint,
    output  int           o_int,
    output  integer       o_integer,
    output  longint       o_longint,
    output  shortreal     o_shortreal,
    output  real          o_real,
    output  time          o_time,
    output  realtime      o_realtime
  );
  endmodule
  """
  And a file named "expect.rb" with:
  """
  class Leaf < VerilogGen::HdlModule
    set_proxy true
    set_file_name "leaf.v"
    set_module_name "leaf"
    add_port "o_logic_bit", direction: "output", type: "bit"
    add_port "o_logic_vector", direction: "output", packed: "[3:0]", type: "logic"
    add_port "o_reg_bit", direction: "output", type: "reg"
    add_port "o_reg_vector", direction: "output", packed: "[31:0]", type: "reg"
    add_port "o_bit_bit", direction: "output", type: "bit"
    add_port "o_bit_vector", direction: "output", packed: "[7:0]", type: "bit"
    add_port "o_byte", direction: "output", type: "byte"
    add_port "o_shortint", direction: "output", type: "shortint"
    add_port "o_int", direction: "output", type: "int"
    add_port "o_integer", direction: "output", type: "integer"
    add_port "o_longint", direction: "output", type: "longint"
    add_port "o_shortreal", direction: "output", type: "shortreal"
    add_port "o_real", direction: "output", type: "real"
    add_port "o_time", direction: "output", type: "time"
    add_port "o_realtime", direction: "output", type: "realtime"
  end
  """
  When I run `csh -c '../../bin/vscan leaf.v > leaf.rb'`
  Then a file named "leaf.rb" should exist 
  When I run `hdl_equal expect.rb leaf.rb`
  Then the exit status should be 0
