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

    def add(*objects)
      objects.each do |object|
        if object.instance_of?(Port)
          if ports.keys.include?(object.name)
            raise ArgumentError, 
                  "Duplicate port name '#{object.name}' detected"
          else
            ports[object.name] = object
          end
        elsif object.instance_of?(HdlModule)
          if child_instances.keys.include?(object.name)
            raise ArgumentError, 
                  "Duplicate module instance name '#{object.name}' detected"
          else
            child_instances[object.name] = object
          end
        else
          raise ArgumentError, "Invalid object type for add operation" 
        end
      end
    end

  end
end
  
