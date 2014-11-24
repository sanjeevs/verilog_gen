module VerilogGen
  # Base class for all verilog modules.
  #   This class holds all the common code that is shared with all the actual
  #   verilog modules.
  #
  class HdlModule


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
    # Add a instance to the design.
    # @param [HdlModule] child instance of the design.
    # @param [String] instance_name
    # @return [HdlModule] child instance added.
    # @note Raises exception if the child instance is not unique.
    def self.add_child_instance(klass, name)
      if child_instances.keys.include?(name)
        raise ArgumentError, 
          "Duplicate module instance name '#{name}' detected"
      else
        child_instances[name] = klass.new(name) 
        method_name = name.to_sym
        define_singleton_method(method_name) do
          child_instances[name]
        end
        return child_instances[name]
      end
    end



    # Get the module name
    # @note If not set then sets it to snake case version of class name.
    def self.module_name
      @module_name ||= self.name.split('::')[1].snakecase
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

    # Convienence routine for adding pin to ports.
    # @note Creates a pin indexed by the port name
    def method_missing(name, *args)
      string_name = name.to_s
      return super unless self.class.ports.has_key? string_name
      if pins.has_key?(string_name)
        pin = pins[string_name]
      else
        pin = Pin.new(self.class.ports[string_name])
        @pins[string_name] = pin
      end
      pin
    end

    # Render the ruby code to verilog.
    # @param [Template] ERB file for verilog template.
    # @return [String] completed template.
    # @note Searches for template in curent dir and then 'templates' dir.
    def render(template_file)
      unless File.exist?(template_file) 
        root = Pathname.new(__FILE__).parent.parent.join('templates')
        template_file = "#{root}#{File::SEPARATOR}#{template_file}"
      end
      File.open(template_file) do |fh|
        template = ERB.new(fh.read, nil, '>')
        template.result(binding)
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
