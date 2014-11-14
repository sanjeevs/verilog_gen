module VerilogGen
  # Base class for all verilog modules.
  #
  # This class holds all the common code that is shared with all the actual
  # verilog modules.
  #
  class HdlModule
    attr_reader :instance_name, :module_name, :ports, :pins, :child_instances

    # Public: Create a hdl module with a name.
    #
    # The name of the module must be unique in a design. 
    # The verilog module name is a snakecase version of the ruby name.
    def initialize(name)
      #Sane defaults for the derived classes
      @instance_name = name
      @ports = {}
      @pins = {}
      @child_instances = {}
      @module_name = self.class.name.split('::')[1].snakecase
      build
    end

    # Public: Template method that is overwritten by the actual class.
    #
    def build
      #Override this to add the ports and child instances.
    end

    # Public: Add a port to the module.
    #
    # name - The name of the port.
    # params - Attributes of the port like direction, width ...etc
    #
    # Raises exception if the port name is not unique 
    def add_port(name, params = {})
      if ports.keys.include?(name)
        raise ArgumentError, 
                  "Duplicate port name '#{name}' detected"
      else
        ports[name] = Port.new(name, params)
        method_name = name.to_sym
        self.class.send :define_method, method_name do
          ports[name]
        end
      end
    end

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

    def ==(other) 
      return instance_name == other.instance_name \
             && module_name == other.module_name \
             && ports == other.ports \
             && pins == other.pins \
             && child_instances == other.child_instances 
    end
  end
end
  
