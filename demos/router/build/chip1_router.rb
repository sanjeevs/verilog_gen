require "generic_router"

# Monkey patch the original class since we are only doing extra.
class Router 
  set_module_name "chip1_router"

  src_mem = VerilogGen.leaf("Mem_16nm_ram4x64", 
                            file_name: "vendors/vendor1/mem_16nm_ram4x64.v")
  2.times do |i|
    m = replace_child_instance "src_fifo_#{i}.memory_inst", src_mem 
    m.mem_wr_data.connect "push_data"
    m.mem_rd_data.connect "pop_data"
  end

  dst_mem = VerilogGen.leaf("Mem_16nm_ram8x64", 
                            file_name: "vendors/vendor1/mem_16nm_ram8x64.v")
  replace_child_instance "dst_fifo.memory_inst", dst_mem 

  # Connect pins to ports that do not match.
  dst_fifo.memory_inst.mem_wr_data.connect "push_data"
  dst_fifo.memory_inst.mem_rd_data.connect "pop_data"


  # Add a BIST controller and properly wire up ports to memories
  add_child_instance "bist_ctrl_inst", 
                      VerilogGen.leaf("Mem_16nm_bist_ctrl",
                      file_name: "vendors/vendor1/mem_16nm_bist_ctrl.v")

  class << self
    alias generic_router_connect connect
  end

  def self.connect
    generic_router_connect
    # Wire to input FIFO memories
    2.times do |i|
      child_instance = child_instances["src_fifo_#{i}"]
      child_instance.memory_inst.bist_en.connect "bist_en_#{i}"
      child_instance.memory_inst.bist_addr.connect "bist_addr_#{i}"
      child_instance.memory_inst.bist_wr_data.connect "bist_wr_data_#{i}"
      child_instance.memory_inst.bist_rd_data.connect "bist_rd_data_#{i}"
    end
    # Wire to output FIFO memory
    dst_fifo.memory_inst.pins.each do |name, pin|
      if name =~ /bist/
        pin.connect "#{name}_2" unless name =~ /clk/
      end
    end
  end
end
