# vscan v0.3.2

# --------------------------------------------------
class Fifo_ctrl_4d < VerilogGen::HdlModule
  set_proxy true
  set_file_name "fifo_ctrl.v"
  set_module_name "fifo_ctrl"
  set_parameter DEPTH: 8
  add_port "clk", direction: "input", type: "wire"
  add_port "empty", direction: "output", type: "reg"
  add_port "full", direction: "output", type: "reg"
  add_port "mem_rd_addr", direction: "output", type: "reg", packed: "[2:0]"
  add_port "mem_rd_en", direction: "output", type: "wire"
  add_port "mem_wr_addr", direction: "output", type: "reg", packed: "[2:0]"
  add_port "mem_wr_en", direction: "output", type: "wire"
  add_port "pop", direction: "input", type: "wire"
  add_port "push", direction: "input", type: "wire"
  add_port "reset", direction: "input", type: "wire"
end

