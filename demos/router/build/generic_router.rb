# Create a generic router.
#

# Create a 4x64 fifo using a generic memory model.
class Fifo_4x64 < VerilogGen::HdlModule
  # Import the verilog leaf modules.
  Fifo_ctrl_4d = VerilogGen.leaf("Fifo_ctrl_4d", 
                                 file_name: "rtl/fifo_ctrl.v",
                                 parameter: "DEPTH=4")

  Generic_mem_4x64 = VeriloGen.leaf("Generic_mem_4x64",
                                    file_name: "rtl/generic_mem.v",
                                    parameter: "DEPTH=4 WIDTH=64")
  # Instantiate the leaf modules.
  add_child_instance "fifo_ctrl_inst", Fifo_ctrl_4d
  add_child_instance "memory_inst", Generic_mem_4x64

  # Connect pins to ports that do not match.
  def self.connect
    memory_inst.mem_wr_data.connect "push_data"
    memory_inst.mem_rd_data.connect "pop_data"
  end

end

# Create 8x64 fifo using generic memory model.
class Fifo_8x64 < VerilogGen::HdlModule
  # Import the verilog leaf modules.
  Fifo_ctrl_8d = VerilogGen.leaf("Fifo_ctrl_4d", 
                                 file_name: "rtl/fifo_ctrl.v",
                                 parameter: "DEPTH=8")

  Generic_mem_8x64 = VeriloGen.leaf("Generic_mem_4x64",
                                    file_name: "rtl/generic_mem.v",
                                    parameter: "DEPTH=8 WIDTH=64")
  add_child_instance "fifo_ctrl_inst", Fifo_ctrl_8d
  add_child_instance "memory_inst", Generic_mem_8x64
  # Connect pins to ports that do not match.
  def self.connect
    memory_inst.mem_wr_data.connect "push_data"
    memory_inst.mem_rd_data.connect "pop_data"
  end
end

# Create a router with src fifo, router ctrl and dst fifo.
class Router < VerilogGen::HdlModule
  clients = 2
  width = 64

  set_module_name "generic_router"

  # Create 2 instances of src fifo.
  src_fifo_lst = []
  clients.times do |i|
    src_fifo_lst << add_child_instance "src_fifo_#{i}", Fifo_4x64
  end

  # Add arbiter
  add_child_instance "arb", Rr_arb

  # Add our router controller
  Router_ctrl_64bit = VerilogGen.leaf("Router_ctrl_64bit", 
                                      file_name: "rtl/router_ctrl.v",
                                      parameter: "WIDTH=64")

  add_child_instance "router_ctrl", Router_ctrl_64bit

  # Hook its output to the dst fifo.
  add_child_instance "dst_fifo", Fifo_8x64

  router_ctrl.empty.connect "src_fifo_empty"
  router_ctrl.pop.connect "src_fifo_pop"
  router_ctrl.data_in.connect "src_fifo_data"

  dst_fifo.push_data.connect "data_out"
  clients.times do |i|
    src_fifo_lst[i].empty.connect "src_fifo_empty", lhs: i, rhs: i 
    src_fifo_lst[i].pop.connect "src_fifo_pop", lhs: i, rhs: i 
    rhs = width * i
    lhs = rhs + width - 1
    src_fifo_lst[i].pop_data.connect "src_fifo_data", lhs: lhs, rhs: rhs
    src_fifo_lst[i].push_data.connect "client_data", lhs: lhs, rhs: rhs
    src_fifo_lst[i].push.connect "client_push", lhs: i, rhs: i
    src_fifo_lst[i].empty.connect "client_empty", lhs: i, rhs: i
  end
  dst_fifo.empty.connect "router_empty"
  dst_fifo.pop.connect "router_pop"
  dst_fifo.pop_data.connect "router_data"

end
