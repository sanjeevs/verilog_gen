Feature: convert a system verilog format to ruby.
  @wip
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
    sub_intf s1, s2;
  endinterface: intf

  module leaf (
    input wire clk,
          intf port_interface
  );
  endmodule
  """
  And a file named "expect.rb" with:
  """
  class Leaf < VerilogGen::HdlModule
    set_proxy true
    set_file_name "leaf.sv"
    set_module_name "leaf"
    add_port "clk", direction: "input", type: "wire"
    add_interface "port_interface", type: "intf"
  end
  class Intf < VerilogGen::HdlInterface
    set_proxy true
    set_file_name "leaf.sv"
    set_interface_name "intf"
    add_port "in1", direction: "input", type: "logic", packed: "[3:0]"
    add_port "in2", direction: "output", type: "logic", packed: "[3:0]"
    add_port "out", direction: "output", type: "logic", packed: "[2:0]"
  end
  class Sub_intf < VerilogGen::HdlInterface
    set_proxy true
    set_file_name "leaf.sv"
    set_interface_name "sub_intf"
  end
  """
  When I run `csh -c '../../bin/vscan leaf.sv > leaf.rb'`
  Then a file named "leaf.rb" should exist 
  When I run `hdl_equal expect.rb leaf.rb`
  Then the exit status should be 0
