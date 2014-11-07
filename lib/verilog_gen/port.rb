module VerilogGen
  class Port
    attr_reader :name, :direction, :width

    def initialize(name, params = {})
      @name = name
      @direction = :input
      @width = 1
      params.each do |key, value|
        raise ArgumentError, 
              "invalid value of port field" unless defined? key
        instance_variable_set("@#{key}", value)
      end

      #Enumeration checking.
      raise ArgumentError, "direction is not valid" unless @direction == :input or @direction == :output
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

    def type
      if direction == :output and width == 1
        return "logic"
      elsif direction == :output
        return "logic [#{width-1}:0]"
      elsif direction == :input and width > 1
        return "[#{width-1}:0]"
      else
        return ""
      end
    end

  end
end
