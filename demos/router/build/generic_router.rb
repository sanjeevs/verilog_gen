# Create a generic router.
#

# Create a fifo using a generic memory model.
class Fifo_4x64 < VerilogGen::HdlModule
  Fifo_ctrl_4d = VerilogGen.leaf("Fifo_ctrl_4d", 
                                 file_name: "rtl/fifo_ctrl.v",
                                 parameter: "DEPTH=4")

  Generic_mem_4x64 = VeriloGen.leaf("Generic_mem_4x64",
                                    file_name: "rtl/generic_mem.v",
                                    parameter: "DEPTH=4 WIDTH=64")

  add_child_instance "fifo_ctrl_inst", Fifo_ctrl_4d
  add_child_instance "memory_inst", Generic_mem_4x64
  memory_inst.mem_wr_data.connect "push_data"
  memory_inst.mem_rd_data.connect "pop_data"
end

class Fifo_8x64 < VerilogGen::HdlModule
  add_child_instance "fifo_ctrl_inst", Fifo_ctrl_8d
  add_child_instance "memory_inst", Generic_mem_8x64
  memory_inst.mem_wr_data.connect "push_data"
  memory_inst.mem_rd_data.connect "pop_data"
end

class Generic_router_2x64b < VerilogGen::HdlModule
  clients = 2
  width = 64

  set_module_name "router"
  clients.times do |i|
    add_child_instance "src_fifo_#{i}", Fifo_4x64
  end
  add_child_instance "arb", Rr_arb
  add_child_instance "router_ctrl", Router_ctrl_64bit
  add_child_instance "dst_fifo", Fifo_8x64

  router_ctrl.empty.connect "empty", width: #{clients}
  router_ctrl.pop.connect "pop", width: #{clients}
  router_ctrl.data_in_#{i}.connect "data_in_array", width: #{clients}*#{width}

  clients.times do |i|
    src_fifo_#{i}.empty.connect "empty", lsb: i
    src_fifo_#{i}.pop.connect "pop", lsb: i
    src_fifo_#{i}.pop_data.connect "data_in_array", lsb #{width}*#{i}
    src_fifo_#{i}.push.connect "client_#{i}_push"
    src_fifo_#{i}.empty.connect "client_#{i}_empty"
    src_fifo_#{i}.push_data.connect "client_#{i}_data"
  end

  dst_fifo.empty.connect "router_empty"
  dst_fifo.pop.connect "router_pop"
  dst_fifo.pop_data.connect "router_data"
  dst_fifo.push_data.connect "data_out"

end
