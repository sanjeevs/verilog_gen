require_relative "generic_router.rb"

# Monkey patch the original class since we are only doing extra.
class Router 
  set_module_name "chip1_router"

  src_mem = VerilogGen.leaf("Mem_16nm_ram4x64", 
                          file_name: "vendors/vendor1/mem_16nm_ram4x64.v")
  2.times do |i|
    replace_child_instance "src_fifo_#{i}.memory_inst", src_mem 
  end

  dst_mem = VerilogGen.leaf("Mem_16nm_ram8x64", 
                          file_name: "vendors/vendor1/mem_16nm_ram8x64.v")
  replace_child_instance "dst_fifo.memory_inst", dst_mem 

  # Add a BIST controller and properly wire up ports to memories
  add_child_instance "bist_ctrl_inst", Mem_16nm_bist_ctrl

  # Wire to input FIFO memories
  2.times do |i|
    child_instance = child_instances["src_fifo_#{i}"]
    child_instance.memory_inst.bist_en.connect "bist_en_#{i}"
    child_instance.memory_inst.bist_addr.connect "bist_addr_#{i}"
    child_instance.memory_inst.bist_wr_data.connect "bist_wr_data_#{i}"
    child_instance.memory_inst.bist_rd_data.connect "bist_rd_data_#{i}"
  end
  # Wire to output FIFO memory
  dst_fifo.memory_inst.ports.each do |i|
    if i.name =~ /bist/
      i.connect "#{i.name}_2" unless i.name =~ /clk/
    end
  end
end
end
