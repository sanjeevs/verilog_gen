class Chip2_router < VerilogGen::HdlModule

  # Treat chip1 as a leaf module.
  chip1_router = VerilogGen.leaf("Router",
                                 file_name: "out/chip1_router/chip1_router.v")
  add_child_instance "chip1", chip1_router
  chip1.clk.connect "clk"
  chip1.vld.connect "vld"

  # For each pin of chip1, except clk/reset, add a repeater flop
  chip1.pins.each do |name, pin|
    next if name =~ /^clk$/ || name =~ /^reset$/
    pin.connect "#{name}_i"

    # Create repeater flops
    Fd_class = VerilogGen.leaf("Flop_delay", 
                               file_name: "rtl/flop_delay.v",
                               parameter: "WIDTH=#{pin.width} DEPTH=2")
    repeater = add_child_instance "repeater_#{name}", Fd_class
    if pin.direction =~ /input/
      repeater.i.connect name
      repeater.o.connect "#{name}_i"
    else
      repeater.i.connect "#{name}_i"
      repeater.o.connect name
    end
  end
end
