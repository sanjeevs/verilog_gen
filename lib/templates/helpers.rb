module DisplayHelpers

  def v2k_port_decl(klass)
    output = ""
    klass.ports.values[0..-2].each do |port| 
      output += "  #{port.direction} #{port.type} #{port.name},\n"
    end
    last_port = klass.ports.values.last
    output += "  #{last_port.direction} #{last_port.type} #{last_port.name}\n" if last_port
  end

  def v2k_child_instances(klass)
    output = ""
    klass.child_instances.each do |inst_name, module_inst| 
      output += "  #{module_inst.class.name} #{inst_name}(\n" 
      module_inst.class.ports.keys[0..-2].each do |port_name|
        output += "    .#{port_name}(#{module_inst.pins[port_name].name}),\n"
      end
      port_name = module_inst.class.ports.keys.last 
      output += "    .#{port_name}(#{module_inst.pins[port_name].name})\n"
      output += "  );\n"
    end
    output
  end
end

