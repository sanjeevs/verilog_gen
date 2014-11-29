module DisplayHelpers

  # Render verilog port declaration.
  # @return [String] verilog decl
  # @example
  #    input reg clk,
  #    output wire vld

  def v2k_port_decl(klass)
    output = ""
    klass.ports.values[0..-2].each do |port| 
      output += "  #{port.direction} #{port.type} #{port.name},\n"
    end
    last_port = klass.ports.values.last
    output += "  #{last_port.direction} #{last_port.type} #{last_port.name}\n" if last_port
  end

  # Create verilog parameter string.
  # @example
  # ram #(.DATA_WIDTH(16), .ADDR_WIDTH(8)) ram(clk, ...); 
  def v2k_parameters(hdl_class)
    output = ""
    unless hdl_class.parameters.empty?
      output = "#("
      hdl_class.parameters.keys[0..-2].each do |k|
        output += ".#{k}(#{hdl_class.parameters[k]}), "
      end
      k = hdl_class.parameters.keys[-1]
      output += ".#{k}(#{hdl_class.parameters[k]}))"
    end
    return output
  end

  # Render child instances.  
  # @return [String] verilog decl
  # @example
  #    cntlr cntlr_inst (
  #      .clk_port(clk_pin),
  #      .rst_port(rst_pint)
  #      );
  #      // if parameters.
  #    cntlr #(DEPTH=4) cntlr_inst (
  def v2k_child_instances(klass)
    output = ""
    klass.child_instances.each do |instance_name, hdl_instance| 
      output = "  #{hdl_instance.class.module_name}"
      p =  v2k_parameters(hdl_instance.class)
      output += " #{p}" unless p == ""
      output += " #{instance_name}(\n"
      hdl_instance.class.ports.keys[0..-2].each do |port_name|
        output += "    .#{port_name}(#{hdl_instance.pins[port_name].name}),\n"
      end
      port_name = hdl_instance.class.ports.keys.last 
      output += "    .#{port_name}(#{hdl_instance.pins[port_name].name})\n"
      output += "  );\n"
    end
    output
  end

end

