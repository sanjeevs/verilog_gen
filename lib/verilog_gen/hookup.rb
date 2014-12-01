module VerilogGen
  def self.create_pins(instance)
    instance.class.ports.each do |name, port|
      instance.pins[name] = Pin.new(port) unless instance.pins.key? name
     end
  end
  def self.create_pins_depth_first(instance)
    if instance.class.proxy
      instance.class.ports.each do |name, port|
        instance.pins[name] = Pin.new(port) unless instance.pins.key? name
      end
    else 
      instance.class.child_instances.each do |child_name, child|
        create_pins_depth_first child
      end
    end
  end

  def self.hookup(top_level_class)
    top_level_class.child_instances.each do |instance_name, instance|
      create_pins_depth_first(instance)
      create_default_ports(instance.class) 
      create_pins(instance)
    end
    create_default_ports(top_level_class) 

  end

  def self.get_child_pins_connectivity(klass)
    pin_connections = Hash.new {|hash, key| hash[key] = Array.new }
    klass.child_instances.each do |child_name, child|
      child.pins.each do |name, pin|
        pin_connections[name].push pin.port
      end
    end
    pin_connections
  end  
  

  def self.unconnected_input?(port_lst)
    return false if port_lst.empty?
    port_lst.each do |port|
      return false unless port.direction == "input"
    end
    return true
  end

  def self.unconnected_output?(port_lst)
    return false if port_lst.empty?
    port_lst.each do |port|
      return false unless port.direction == "output"
    end
    return true
  end

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
  def self.create_default_ports(klass)
    pin_connections = get_child_pins_connectivity(klass)
    pin_connections.each do |name, port_lst|
      sample = port_lst[0]
      sample.update_width(super_port_width(port_lst))
      if unconnected_input?(port_lst)
        klass.ports[name] = sample
      elsif unconnected_output?(port_lst)
        klass.ports[name] = sample
      end
    end  
  end
end
