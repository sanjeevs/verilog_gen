module DisplayHelpers

  # Render verilog port declaration.
  # @return [String] verilog decl
  # @example
  #    input reg clk,
  #    output wire [1:0] vld

  def v2k_port_decl(port)
    output = "#{port.direction} #{port.type}"
    output += " [#{port.lhs}:#{port.rhs}]" unless port.scalar?
    output += " #{port.name}"
  end

  def v2k_port_list_decl(klass)
    output = ""
    klass.ports.values[0..-2].each do |port|
      output += "  #{v2k_port_decl(port)},\n"
    end
    last_port = klass.ports.values.last
    if last_port
      output += "  #{v2k_port_decl(last_port)}\n"
    end
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

  def v2k_port_instance(port_name, hdl_instance)
    output = ""
    if hdl_instance.pins.key? port_name
      pin = hdl_instance.pins[port_name]
      if not pin.port.scalar?
        output = ".#{port_name}(#{pin.name}"
        output += "[#{pin.lhs}:#{pin.rhs}])"
      else
        output = ".#{port_name}(#{pin.name})"
      end
    else
      output = ".#{port_name}()"
    end
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
      output += "  #{hdl_instance.class.module_name}"
      p =  v2k_parameters(hdl_instance.class)
      output += " #{p}" unless p == ""
      output += " #{instance_name}(\n"
      hdl_instance.class.ports.keys[0..-2].each do |port_name|
        output += "    #{v2k_port_instance(port_name, hdl_instance)},\n"
      end
      port_name = hdl_instance.class.ports.keys.last
      if port_name
        output   += "    #{v2k_port_instance(port_name, hdl_instance)}\n"
      end
      output += "  );\n"
    end
    output
  end

end

