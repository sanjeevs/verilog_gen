Feature: Generate a v2k code for demo fifo ctrl

  Scenario: Demo fifo ctrl 
  Given a file named "fifo_ctrl.rb" with:
  """
class Fifo_ctrl_4d < VerilogGen::HdlModule
  set_proxy true
  set_file_name "fifo_ctrl.v"
  set_module_name "fifo_ctrl"
  set_parameter DEPTH: 4
  add_port "clk", direction: "input", type: "wire"
  add_port "empty", direction: "output", type: "reg"
  add_port "full", direction: "output", type: "reg"
  add_port "mem_rd_addr", direction: "output", type: "reg", packed: "[1:0]", lhs: 1, rhs: 0"
  add_port "mem_rd_en", direction: "output", type: "wire"
  add_port "mem_wr_addr", direction: "output", type: "reg", packed: "[1:0]", lhs: 1, rhs: 0"
  add_port "mem_wr_en", direction: "output", type: "wire"
  add_port "pop", direction: "input", type: "wire"
  add_port "push", direction: "input", type: "wire"
  add_port "reset", direction: "input", type: "wire"
end

  """
  When I run `vgen -t Fifo_ctrl_4d fifo_ctrl.rb`
  Then a file named "fifo_ctrl_4d.v" should exist 
