module VerilogGen
  # Model of a pin connected to a port
  class Pin

    attr_reader :port, :name, :type, :lhs, :rhs, :direction
   
    # A pin connects to a port. 
    # @note By default the pin name, type and width is the same as port.
    def initialize(port)
      @port = port
      @name = port.name
      @type = port.type
      @lhs = port.lhs 
      @rhs = port.rhs 
      @direction = port.direction
    end

    # Update a pin attributes.
    # @param [String] name of the pin
    # @param [Hash] params properties of pin
    # @option params [String] :name name of the pin
    # @option params [String] :type type of the pin
    # @option params [Fixnum] :lhs left hand width of the pin
    # @option params [Fixnum] :rhs right hand width of the pin
    # @option params [String] :direction of the pin
    def connect(name, params = {})
      @name = name
      params.each do |key, value|
        raise ArgumentError, "Unknown attribute '#{key}' specified for pin" \
              unless instance_variables.include?("@#{key}".to_sym)
        instance_variable_set("@#{key}", value)
      end
    end

    def width
      (@lhs - @rhs + 1).abs
     end
  end
end
