Feature: convert a system verilog format to ruby.

  Scenario: System Verilog interfaces (nested)
  Given a file named "leaf.sv" with: 
  """
  interface intf (
    input  logic [3:0] in1, in2,
    output       [2:0] out,
  );
    interface sub_intf;
      wire pin;
    endinterface: sub_intf;
    sub_intf s1, s2
  endinterface: intf

  module leaf (
    input wire clk,
          intf port_interface
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
      add_port "clk", direction: "input", type: "wire"
      add_interface "port_interface", type: "intf"
    end
  end
  class Intf < HdlInterface
    def initialize
      proxy = true
      file_name = "leaf.v"
      interface_name = "intf"
      add_port "in1", direction: "input", type: "logic", packed: "[3:0]"
      add_port "in2", direction: "output", type: "logic", packed: "[3:0]"
      add_port "out", direction: "output", type: "logic", packed: "[2:0]"
    end
  end
  class Sub_intf < HdlInterface
    def initialize
      proxy = true
      file_name = "leaf.v"
      interface_name = "sub_intf"
    end
  end
  """
  When I run `vscan leaf.sv`
  Then a file named "leaf.rb" should exist 
  When I run `hdl_equal expect.rb leaf.rb`
  Then the exit status should be 0
