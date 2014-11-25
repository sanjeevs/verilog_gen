class Fifo_4x64 < VerilogGen::HdlModule
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
  set_module_name "router"
  2.times do |i|
    add_child_instance "src_fifo_#{i}", Fifo_4x64
  end
  add_child_instance "arb", Rr_arb
  add_child_instance "router_ctrl", Router_ctrl_64bit
  add_child_instance "dst_fifo", Fifo_8x64

  router_ctrl.empty.connect "empty", width: 2
  router_ctrl.pop.connect "pop", width: 2
  router_ctrl.data_in.connect "data_in_array", width: 64, size: 2

  2.times do |i|
    src_fifo_#{i}.empty.connect "empty", lsb: i
    src_fifo_#{i}.pop.connect "pop", lsb: i
    src_fifo_#{i}.pop_data.connect "data_in_array", width: 64, index: i
    src_fifo_#{i}.push.connect "client_#{i}_push"
    src_fifo_#{i}.empty.connect "client_#{i}_empty"
    src_fifo_#{i}.push_data.connect "client_#{i}_data"
  end

  dst_fifo.empty.connect "router_empty"
  dst_fifo.pop.connect "router_pop"
  dst_fifo.pop_data.connect "router_data"
  dst_fifo.push_data.connect "data_out"

end
