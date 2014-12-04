Feature: convert a system verilog format to ruby.
  @wip
  Scenario: System Verilog interfaces (with parameters)
  Given a file named "leaf.sv" with: 
  """
  interface intf #(PARAM1=3) (
    input  logic [PARAM1:0]   in1, in2,
    output       [PARAM1-1:0] out
  );
  wire pin;
  endinterface: intf
  """
  And a file named "expect.rb" with:
  """
  class Intf_wide < VerilogGen::HdlInterface
    set_proxy true
    set_file_name "leaf.sv"
    set_interface_name "intf"
    add_port "in1", direction: "input", type: "logic", packed: "[5:0]"
    add_port "in2", direction: "output", type: "logic", packed: "[5:0]"
    add_port "out", direction: "output", type: "logic", packed: "[4:0]"
  end
  """
  When I run `csh -c '../../bin/vscan PARAM1=5 -class Intf_wide leaf.sv > Intf_wide.rb'`
  Then a file named "Intf_wide.rb" should exist 
  When I run `hdl_equal expect.rb Intf_wide.rb`
  Then the exit status should be 0
