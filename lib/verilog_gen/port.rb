module VerilogGen
  class Port
    attr_reader :name, :direction, :width

    def initialize(name, params = {})
      @name = name
      @direction = "input"
      @width = 1
      params.each do |key, value|
        raise ArgumentError, 
              "invalid value of port field" unless defined? key
        instance_variable_set("@#{key}", value)
      end

      #Enumeration checking.
      raise ArgumentError, "direction is not valid" unless @direction == "input" or @direction == "output"
    end

    #Value checking
    def ==(other)
      name == other.name && direction == other.direction && width == other.width
    end

    #Value checking + Type checking
    def eql?(other)
      other.kind_of?(self.class) and self.==(other)
    end
    
    def hash
      return name.hash ^ direction.hash ^ width.hash
    end

  end
end
