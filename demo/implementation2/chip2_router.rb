require_relative "../generic_view/generic_router.rb"

class chip1_router < Generic_router_2x64b
  2.times do |i|
    replace_child_instance "src_fifo_#{i}.memory_inst", Mem_16nm_ram4x64
  end
  replace_child_instance "dst_fifo.memory_inst", Mem_16nm_ram8x64

  add_child_instance "bist_ctrl_inst", Mem_16nm_bist_ctrl
end
