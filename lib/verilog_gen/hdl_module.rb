module VerilogGen
  # Base class for all verilog modules.
  #   This class holds all the common code that is shared with all the actual
  #   verilog modules.
  #
  class HdlModule
    attr_reader :module_name, :instance_name, :ports, :pins, :child_instances

    # Default arguments for derived class. 
    def initialize(instance_name)
      #Sane defaults for the derived classes
      @ports = {}
      @pins = {}
      @child_instances = {}
      @module_name = self.class.name.split('::')[1].snakecase
      @instance_name = instance_name
    end

    def build
    end

    # Add a port to the design.
    # @param [String] name of the port.
    # @param [String] params of port.
    # @return [HdlPort] new port created.
    # @note Raises exception if the port name is not unique 
    def add_port(name, params = {})
      if ports.keys.include?(name)
        raise ArgumentError, 
                  "Duplicate port name '#{name}' detected"
      else
        ports[name] = Port.new(name, params)
        method_name = name.to_sym
        # create the get accessor
        self.class.send :define_method, method_name do
          ports[name]
        end
      end
    end

    # Add a instance to the design.
    # @param [HdlModule] child instance of the design.
    # @param [String] instance_name
    # @return [HdlModule] child instance added.
    # @note Raises exception if the child instance is not unique.
    def add_instance(klass, name)
      if child_instances.keys.include?(name)
        raise ArgumentError, 
             "Duplicate module instance name '#{name}' detected"
      else
        child_instances[name] = klass.new(name) 
        method_name = name.to_sym
        self.class.send :define_method, method_name do
          child_instances[name]
        end
      end
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
    # @return true if the hdl module match.
    # @note instance name is not compared.
    def ==(other) 
      return true if other.equal?(self)
      return false unless other.instance_of?(self.class)
      module_name == other.module_name \
        && ports == other.ports \
        && pins == other.pins \
        && child_instances == other.child_instances 
    end

    # Well behaved hash key.
    # @param [HdlModule] 
    # @return true if the hash keys are equal.
    # @note if a.eql?(b) then a.hash = b.hash
    def eql?(other)
      return false unless other.instance_of?(self.class)
      module_name == other.module_name \
      && instance_name == other.instance_name
    end

    # Calculate the hash.
    # @return [Numeric] hash value 
    # @note if a.eql?(b) then a.hash = b.hash
    def hash
      module_name ^ instance_name
    end

  end
end
  
