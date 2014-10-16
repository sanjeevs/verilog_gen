module VerilogGen
  class HdlModule
    attr_reader :name, :ports, :pins, :child_instances

    def initialize(name)
      @name = name
      @ports = {}
      @pins = {}
      @child_instances = {}
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
  end
end
  
