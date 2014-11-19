Feature: convert a verilog 1364-2001 format to ruby.

  Scenario: More complex port types (note, only reg/wire can be on the
            receiving side and reg/wire/integer on the driving side).
  Given a file named "leaf.v" with: 
  """
  module leaf (
    output  wire         o_wire_bit,
    output  wire [10:-4] o_wire_vector,
    output  reg          o_reg_bit,
    output  reg  [-3:-4] o_reg_vector,
    output  integer      o_integer,
    output  real         o_real,
    output  realtime     o_realtime
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
      add_port "o_wire_bit", direction: "output", type: "wire"
      add_port "o_wire_vector", direction: "output", packed: "[10:-4]", type: "wire"
      add_port "o_reg_bit", direction: "output", type: "reg"
      add_port "o_reg_vector", direction: "output", packed: "[-3:-4]", type: "reg"
      add_port "o_integer", direction: "output", type: "integer"
      add_port "o_real", direction: "output", type: "real"
      add_port "o_realtime", direction: "output", type: "realtime"
    end
  end
  """
  When I run `vscan leaf.v`
  Then a file named "leaf.rb" should exist 
  When I run `hdl_equal expect.rb leaf.rb`
  Then the exit status should be 0
