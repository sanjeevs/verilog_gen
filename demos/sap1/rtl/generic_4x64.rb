# vscan v0.3.2

# --------------------------------------------------
class Generic_4x64 < VerilogGen::HdlModule
  set_proxy true
  set_file_name "generic_mem.v"
  set_module_name "generic_mem"
  set_parameter DEPTH: 4
  set_parameter WIDTH: 64
  add_port "clk", direction: "input", type: "wire"
  add_port "mem_rd_addr", direction: "input", type: "wire", packed: "[1:0]"
  add_port "mem_rd_data", direction: "input", type: "wire", packed: "[63:0]"
  add_port "mem_rd_en", direction: "input", type: "wire"
  add_port "mem_wr_addr", direction: "input", type: "wire", packed: "[1:0]"
  add_port "mem_wr_data", direction: "input", type: "wire", packed: "[63:0]"
  add_port "mem_wr_en", direction: "input", type: "wire"
end

