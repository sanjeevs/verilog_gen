class Chip2_router < VerilogGen::HdlModule

  # Treat chip1 as a leaf module.
  chip1_router = VerilogGen.leaf("Router",
                                 file_name: "out/chip1/chip1_router.v")
  add_child_instance "chip1", chip1_router
  
  # For each port of chip1, except clk/reset, add a repeater flop
  chip1.ports.each do |port|
    next if port.name =~ /^clk$/ || port.name =~ /^reset$/
    port.connect "#{port.name}_i"

    # Create repeater flops
    Fd_class = VerilogGen.leaf("Flop_delay", 
                               file_name: "rtl/flop_delay.v",
                               parameter: "WIDTH=#{port.width}, DEPTH=2")
    add_child_instance "repeater_#{port.name}", Fd_class
    if port.direction =~ /input/
      repeater_"#{port.name}".connect "i", #{port.name}
      repeater_"#{port.name}".connect "o", "#{port.name}_i"
    else
      repeater_"#{port.name}".connect "i", "#{port.name}_i"
      repeater_"#{port.name}".connect "o", #{port.name}
    end
  end
end
