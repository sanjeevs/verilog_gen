module VerilogGen
  # Base class for all verilog modules.
  #   This class holds all the common code that is shared with all the actual
  #   verilog modules.
  #
  class HdlModule
    include DisplayHelpers

    def self.ports()
      @ports ||= {}
    end
    # Add a port to the design.
    # @param [String] name of the port.
    # @param [String] params of port.
    # @return [HdlPort] new port created.
    # @note Raises exception if the port name is not unique 
    def self.add_port(name, params = {})
      if ports.keys.include?(name)
        raise ArgumentError, 
          "Duplicate port name '#{name}' detected"
      else
        ports[name] = Port.new(name, params)
        method_name = name.to_sym
        # create the accessor using port name
        define_singleton_method(method_name) do
          ports[name]
        end
        return ports[name]
      end
    end

    def self.child_instances()
      @child_instances ||= {}
    end

    # Convert the hierarical path to the instance.
    # @param [String] Complete hierarichal path.
    # @return [HdlModule, Nil] if no parent then return nil
    def self.get_module_instance(hier_path)
      if child_instances.has_key?(hier_path[0])
        parent = child_instances[hier_path[0]]
      else
        raise ArgumentError, 
            "Unable to resolve starting hier path '#{hier_path}' at '#{hier_path[0]}'"
      end

      hier_path[1..-1].each do |node|
        if parent.class.child_instances.has_key?(node)
          parent = parent.class.child_instances[node]
        else
          raise ArgumentError, 
            "Unable to resolve complete hier path '#{hier_path}' at '#{node}'"
        end 
      end
      return parent
    end

    # Add a instance to the design.
    # @param [String] instance path
    # @param [HdlModule] child class name 
    # @return [HdlModule] child instance added.
    # @example
    #    Adds an instance "fifo_inst" of class Fifo 
    #    add_child_instance("fifo_inst", Fifo) 
    #
    #    Adds an instance at hier "a.b"  
    #    add_child_instance("a.b.fifo_inst", Fifo)
    #
    # @note Raises exception if the child instance is not unique.
    def self.add_child_instance(hier_name, klass)
      parent = nil
      hier_path = hier_name.split('.')
      name = hier_path[-1]
      parent = get_module_instance(hier_path[0..-2]) if hier_path.size > 1
      parent_class = parent ? parent.class : self

      if parent_class.child_instances.keys.include?(name)
        raise ArgumentError, 
          "Duplicate module instance name '#{name}' detected in '#{hier_path}"
      else
        parent_class.child_instances[name] = klass.new(name) 
        method_name = name.to_sym
        define_singleton_method(method_name) do
          parent_class.child_instances[name]
        end
        child = parent_class.child_instances[name]
      end
    end   



    # Get the module name
    # @note If not set then sets it to snake case version of class name.
    def self.module_name
      @module_name ||= name.split('::')[-1].snakecase
    end

    # Set the module name
    # @note Convienence routine for setting the class instance variable.
    #    Using assignment operator confuses ruby interpreter hence set prefix.
    def self.set_module_name(module_name)
      @module_name = module_name
    end

    # Get the proxy.
    def self.proxy
      @proxy ||= false
    end

    # Set the proxy.
    def self.set_proxy(value)
      @proxy = value 
    end


    # Get the file name.
    def self.file_name
      @file_name ||= "" 
    end

    def self.set_file_name(file_name)
      @file_name = file_name
    end

    def file_name(file_name)
      @file_name = file_name
    end

    def self.parameters
      @parameters ||= {} 
    end

    def self.set_parameter param
      param.each do |k, v|
        parameters[k] = v
      end
    end

    # Instance specific state
    attr_reader :instance_name 
    attr_accessor :pins
    def initialize(instance_name)
      @instance_name = instance_name
      @pins =  {}
    end

    # Check If the method name matches a port or child instance name.
    # @return [Pin, Instance] if the name matches a port/child instance.
    # @note if the method matches a port name that does not have a pin, then
    # a default pin is added.
    def method_missing(name, *args)
      string_name = name.to_s
      if self.class.ports.has_key? string_name 
        if pins.has_key?(string_name)
          pin = pins[string_name]
        else
          pin = Pin.new(self.class.ports[string_name])
          @pins[string_name] = pin
        end
        return pin
      elsif self.class.child_instances.has_key?(string_name)
        return self.class.child_instances[string_name]
      else 
        return super  
      end
    end

    # Convienence routine for getting the pin name
    # @param [String] port name
    # @return [String] pin name
    def pin_name(port_name)
      @pins[port_name].name
    end

    def get_binding
      binding
    end

    # Render the ruby code to verilog.
    # @param [Template] ERB file for verilog template.
    # @return [String] completed template.
    # @note Searches for template in curent dir and then 'templates' dir.
    def render(template_file = "v2k_template.erb")
      unless File.exist?(template_file) 
        root = Pathname.new(__FILE__).parent.parent.join('templates')
        template_file = "#{root}#{File::SEPARATOR}#{template_file}"
      end
      File.open(template_file) do |fh|
        template = ERB.new(fh.read, nil, '>')
        template.result(get_binding)
      end
    end

    # Equality of hdl module
    # @param [HdlModule] 
    # @return true if the instance is the same
    def ==(other) 
      return true if other.equal?(self)
      return false unless other.instance_of?(self.class)
      instance_name == other.instance_name && pins == other.pins 
    end

    # Well behaved hash key.
    # @param [HdlModule] 
    # @return true if the hash keys are equal.
    # @note if a.eql?(b) then a.hash = b.hash
    def eql?(other)
      return false unless other.instance_of?(self.class)
      instance_name == other.instance_name 
    end

    # Calculate the hash.
    # @return [Numeric] hash value 
    # @note if a.eql?(b) then a.hash = b.hash
    def hash
      instance_name.hash
    end

  end
end
