Slide Demo
-------------------
* Router module

> 2 source clients, 1 destination client

> All inputs and outputs are FIFO'd

> Round-robin arbitration

* Block diagram

Slide Multiple Views
------------------------
* Generic view
> The design built without concern with implementation details
> Contains leaf-level Verilog files and ruby connectivity scripts
> There are no ifdef's, etc. to pollute code

* Implementation 1 view (chip 1)
> Inherits the generic view
> Contains chip-specific modifications
> Generic memory modules replaced with vendor specific models
> BIST controller added

* Implementation 2 view (chip 2)
> Inherits the chip 1 view
> Contains repeater flops on all I/O pins

Slide Generic View Design (part 1)
------------------------
* Instance Source/Destination FIFOs:

code inserte here (TBD):
class Fifo_4x64 < VerilogGen::HdlModule
  add_child_instance "fifo_ctrl_inst", Fifo_ctrl_4d
  add_child_instance "memory_inst", Generic_mem_4x64
  memory_inst.mem_wr_data.connect "push_data"
  memory_inst.mem_rd_data.connect "pop_data"
end

code inserte here (TBD):
class Fifo_8x64 < VerilogGen::HdlModule
  add_child_instance "fifo_ctrl_inst", Fifo_ctrl_8d
  add_child_instance "memory_inst", Generic_mem_8x64
  memory_inst.mem_wr_data.connect "push_data"
  memory_inst.mem_rd_data.connect "pop_data"
end

Slide Generic View Design (part 2)
------------------------
* Top design and instances:

code inserte here (TBD):
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

  <instance connectivity, see next slide>

end

Slide Generic View Design (part 3)
------------------------
* Top design connectivity

code inserte here (TBD):
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

Slide Chip 1 Implementation (part 1)
------------------------
* Replace generic memories with vendor specific memories

code inserte here (TBD):
require_relative "generic_router.rb"

class chip1_router < Generic_router_2x64b
  2.times do |i|
    replace_child_instance "src_fifo_#{i}.memory_inst", Mem_16nm_ram4x64
  end
  replace_child_instance "dst_fifo.memory_inst", Mem_16nm_ram8x64

  # Add a BIST controller and properly wire up ports to memories
  add_child_instance "bist_ctrl_inst", Mem_16nm_bist_ctrl

  <instance connectivity, see next slide>

Slide Chip 1 Implementation (part 2)
------------------------
* Chip 1 design connectivity changes

code inserte here (TBD):
  # Wire to input FIFO memories
  2.times do |i|
    src_fifo_"#{i}".memory_inst.bist_en.connect "bist_en_#{i}"
    src_fifo_"#{i}".memory_inst.bist_addr.connect "bist_addr_#{i}"
    src_fifo_"#{i}".memory_inst.bist_wr_data.connect "bist_wr_data_#{i}"
    src_fifo_"#{i}".memory_inst.bist_rd_data.connect "bist_rd_data_#{i}"
  end
  # Wire to output FIFO memory
  dst_fifo.memory_inst.ports.each do |i|
    if i.name =~ /bist/
      i.connect "#{i.name}_2" unless i.name =~ /clk/
    end
  end


Slide Chip 2 Implementation (part 1)
------------------------
* Add repeater flops on all external pins (except clock/reset) to design chip 1

code inserte here (TBD):
require_relative "chip1_router.rb"


Slide Chip 2 Implementation (part 2)
------------------------
* Chip 2 design connectivity changes

code inserte here (TBD):
