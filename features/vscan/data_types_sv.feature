Feature: convert a system verilog format to ruby.

  Scenario: More complex port types, note that SV allows all data types
            to be on port lists, including arrays and structures!  This
            test does not test arrays or structures
  Given a file named "leaf.v" with: 
  """
  module leaf (
    output  logic         o_logic_bit,
    output  logic [3:0] o_logic_vector,
    output  reg           o_reg_bit,
    output  reg  [31:0]  o_reg_vector,
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
  class Leaf < HdlModule
    def initialize
      proxy = true
      file_name = "leaf.v"
      module_name = "leaf"
      add_port "o_logic_bit", direction: "output"
      add_oprt "o_logic_vector", direction: "output", packed: "[3:0]"
      add_port "o_reg_bit", direction: "output"
      add_oprt "o_reg_vector", direction: "output", packed: "[31:0]"
      add_port "o_bit_bit", direction: "output"
      add_oprt "o_bit_vector", direction: "output", packed: "[7:0]"
      add_port "o_byte", direction: "output", packed: "[7:0]"
      add_port "o_shortint", direction: "output", packed: "[15:0]"
      add_port "o_int", direction: "output", packed: "[15:0]"
      add_port "o_integer", direction: "output", packed: "[31:0]"
      add_port "o_longint", direction: "output", packed: "[63:0]"
      add_port "o_shortreal", direction: "output", packed: "[31:0]"
      add_port "o_real", direction: "output", packed: "[63:0]"
      add_port "o_time", direction: "output", packed: "[63:0]"
      add_port "o_realtim", direction: "output", packed: "[63:0]"
    end
  end
  """
  When I run `vscan leaf.v`
  Then a file named "leaf.rb" should exist 
  When I run `hdl_equal expect.rb leaf.rb`
  Then the exit status should be 0
