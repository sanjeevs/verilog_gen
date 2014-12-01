class Chip2_router < VerilogGen::HdlModule

  # Treat chip1 as a leaf module.
  chip1_router = VerilogGen.leaf("Router",
                                 file_name: "out/chip1_router/chip1_router.v")
  add_child_instance "chip1", chip1_router
  
  chip1_router.ports.each do |port_name, port|
    next if port_name =~ /clk$/ || port_name =~ /^reset$/
    # Create repeater flops
    xyz = VerilogGen.leaf("Flop_delay_#{port_name}", 
                               file_name: "rtl/flop_delay.v",
                               parameter: "WIDTH=#{port.width} DEPTH=2")
    add_child_instance "repeater_#{port_name}", xyz
  end

  def self.connect
    # For each pin of chip1, except clk/reset, add a repeater flop
    chip1.pins.each do |port_name, pin|
      next if port_name =~ /clk$/ || port_name =~ /^reset$/
      pin.connect "#{port_name}_i"

      repeater = child_instances["repeater_#{port_name}"]
      if pin.direction =~ /input/
        repeater.i.connect port_name
        repeater.o.connect "#{port_name}_i"
      else
        repeater.i.connect "#{port_name}_i"
        repeater.o.connect port_name
      end
    end
  end
end
