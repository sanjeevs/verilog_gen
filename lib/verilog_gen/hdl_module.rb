module VerilogGen
  class HdlModule
    attr_reader :name, :module_name, :ports, :pins, :child_instances

    def initialize(name)
      @name = name
      @ports = {}
      @pins = {}
      @child_instances = {}
      @module_name = self.class.name.split('::')[1].snakecase
      build
    end

    def build
      #Override this to add the ports and child instances.
    end

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
  end
end
  
