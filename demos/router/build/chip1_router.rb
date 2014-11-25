require_relative "generic_router.rb"

class chip1_router < Generic_router_2x64b
  2.times do |i|
    replace_child_instance "src_fifo_#{i}.memory_inst", Mem_16nm_ram4x64
  end
  replace_child_instance "dst_fifo.memory_inst", Mem_16nm_ram8x64

  # Add a BIST controller and properly wire up ports to memories
  add_child_instance "bist_ctrl_inst", Mem_16nm_bist_ctrl
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
end
