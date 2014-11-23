module VerilogGen
  # Model of a pin connected to a port
  class Pin

    attr_reader :port, :name, :type, :width
   
    # A pin connects to a port. 
    def initialize(port)
      @port = port
      @name = port.name
      @type = port.type
      @width = (port.lhs - port.rhs).abs + 1
    end

    # Update a pin attributes.
    def connect(name, params = {})
      @name = name
      params.each do |key, value|
        raise ArgumentError, "Unknown attribute '#{key}' specified for pin" \
              unless instance_variables.include?("@#{key}".to_sym)
        instance_variable_set("@#{key}", value)
      end
    end

  end
end
