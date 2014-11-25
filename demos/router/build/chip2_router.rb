require_relative "chip1_router.rb"

class Chip2_router < VerilogGen::HdlModule
  # instance the chip1
  add_child_instance "chip1", Chip1_router

  # For each port of chip1, except clk/reset, add a repeater flop
  chip1.ports.each do |port|
    next if port.name =~ /^clk$/ || port.name =~ /^reset$/
    port.connect "#{port.name}_i"
    add_child_instance "repeater_#{port.name}", Flop_delay, WIDTH=#{port.width}
    if port.direction =~ /input/
      repeater_#{port.name}.connect "i", #{port.name}
      repeater_#{port.name}.connect "o", "#{port.name}_i"
    else
      repeater_#{port.name}.connect "i", "#{port.name}_i"
      repeater_#{port.name}.connect "o", #{port.name}
    end
  end
end
