module VerilogGen
  
  # Check if all the ports in the list are inputs.
  # @param [Array] port_lst is the list of ports
  # @return [Boolean] True if all are inputs.
  def self.unconnected_input_ports?(port_lst)
    return false if port_lst.empty?
    port_lst.each do |port|
      return false unless port.direction == "input"
    end
    return true
  end

  # Check if all the ports in the list are outputs.
  # @param [Array] port_lst is the list of ports
  # @return [Boolean] True if all are outputs.
  def self.unconnected_output_ports?(port_lst)
    return false if port_lst.empty?
    port_lst.each do |port|
      return false unless port.direction == "output"
    end
    return true
  end
  
  # Find the super width from a list of ports.
  # @param [Array] list of ports
  # @return [Array] lhs, rhs
  # @note: 
  #     Assumes that all ports in the list are of same endiannes..
  #     FIXME: For this it looks at the port in the middle.
  #     Should scan all the ports to detect it.
  def self.super_port_width(port_lst)
    sample_port = port_lst[port_lst.size/2]
    lhs_values = []
    rhs_values = []
    port_lst.each do |port|
      lhs_values << port.lhs
      rhs_values << port.rhs
    end
    if sample_port.lhs > sample_port.rhs
      return lhs_values.max, rhs_values.min
    else
      return lhs_values.min, rhs_values.max
    end
  end

  # Adds a connect port to the hdl module class.
  # @return nil
  # @note The name of the connect port is the name of the pin
  #       and the width of the port is the super width.
  def self.add_new_connect_port(klass, pin_name, port_lst)
    lhs, rhs = super_port_width(port_lst)
    p = port_lst[0].create_connect_port(pin_name, lhs, rhs) 
    klass.ports[pin_name] = p
  end

  # Create pins for unconnected ports in current instance.
  # @param [Object] instance of hdl module
  # @return [Fixnum] Number of pins added
  # @note Ports with existing pins are skippped.
  def self.create_missing_pins(instance)
    num_pins_created = 0
    instance.class.ports.each do |port_name, port|
      unless instance.pins.key? port_name
        instance.pins[port_name] = Pin.new(port)
        num_pins_created += 1
      end
    end
    num_pins_created
  end

  # Create  missing pins for all children below the instance.
  # Use depth first to build all the leaf and then the rest of the
  # modules.
  # @param [Object] instance of the design.
  # @return [nil] 
  # @note Idempotent since port that have pins are skipped.
  def self.create_missing_pins_depth_first(instance)
    if instance.class.proxy
      # Leaf do not change the ports. hence we don't need to do it again.
      # But it is harmless if all ports are already connected. 
      create_missing_pins instance
    else 
      instance.class.child_instances.each do |child_name, child|
        create_missing_pins_depth_first child
      end
      # If new pins are created then we would need to create the connect ports
      # in the current class. 
      num_new_ports = create_connect_ports(instance.class) 

      # Run custom user connect
      instance.class.connect

      # If we added new ports to the class then all instantiaton must get new pins.
      create_missing_pins instance if num_new_ports > 0
    end
  end

  # Create connectivity map for children of a hdl module.
  # @param [Object] klass of the hdl module.
  # @return [Hash] hash of array. PinName => [Port0, Port 10.....]
  # 
  def self.get_child_pins_connectivity(klass)
    pin_connections = Hash.new {|hash, key| hash[key] = Array.new }
    klass.child_instances.each do |child_name, child|
      child.pins.each do |port_name, pin|
        pin_connections[pin.name].push pin.port
      end
    end
    pin_connections
  end

  # Create ports to provide connectivity to the child instances.
  # @param [Object] klass HdlModule
  # @return [Fixnum] number of ports created in the class. 
  # @note
  #     An input port is created if the children pins are inputs. 
  #     A  output port is created if the children pins are output.
  #     If mixture of input and output pins, then no ports are created.
  #     The width of the port is the superset of the width. 
  def self.create_connect_ports(klass)
    num_connect_ports = 0
    pin_connections = get_child_pins_connectivity(klass)
    pin_connections.each do |pin_name, port_lst|
      if unconnected_input_ports?(port_lst)
        add_new_connect_port(klass, pin_name, port_lst)
        num_connect_ports += 1
      elsif unconnected_output_ports?(port_lst)
        add_new_connect_port(klass, pin_name, port_lst)
        num_connect_ports += 1
      end
    end 
    num_connect_ports 
  end

  # Connect child instances and create hookup ports.
  # @param [Object] top_level_class of the design.
  # @note 
  #     Start with each child instance.
  #     
  def self.hookup(top_level_class)
    top_level_class.child_instances.each do |instance_name, instance|
      create_missing_pins_depth_first(instance)
    end
    # Run custom user connect
    top_level_class.connect

    # Create the primary connect ports
    create_connect_ports(top_level_class) 

  end

end
