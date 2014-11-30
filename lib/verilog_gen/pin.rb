module VerilogGen
  # Model of a pin connected to a port
  class Pin

    attr_reader :port, :name, :type, :width
   
    # A pin connects to a port. 
    # @note By default the pin name, type and width is the same as port.
    def initialize(port)
      @port = port
      @name = port.name
      @type = port.type
      @width = 1
    end

    # Update a pin attributes.
    # @param [String] name of the pin
    # @param [Hash] params properties of pin
    # @option params [String] :name name of the pin
    # @option params [String] :type type of the pin
    # @option params [Fixnum] :width width of the pin
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
