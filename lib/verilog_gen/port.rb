module VerilogGen
  # Model of a verilog port.
  class Port
    attr_reader :name, :direction, :lhs, :rhs

    # Construct a port.
    # @param [String] name of the port
    # @param [String] direction of the port
    # @param [Integer] left hand side digit
    # @param [Integer] right hahd side digit
    # @note If lhs and rhs are 0 then it is a scalar port else vector type.
    def initialize(name, params = {})
      @name = name
      @direction = "input"
      @lhs = @rhs = 0
      params.each do |key, value|
        raise ArgumentError, 
              "invalid value of port field" unless defined? key
        instance_variable_set("@#{key}", value)
      end

      #Enumeration checking.
      raise ArgumentError, "direction is not valid" \
                        unless @direction == "input" or @direction == "output"
    end

    # Equaltiy of port
    # @param [Port] rhs port
    # @return [Boolean] comparion result
    def ==(other)
      return false unless other.instance_of?(self.class)
      name == other.name && direction == other.direction \
        && lhs == other.lhs && rhs == other.rhs
    end

    # Well behaved hash keys
    # @param [Port] rhs
    # @return [Boolean] true/false
    # @note if a.eql?(b) then a.hash = b.hash
    def eql?(other)
      return self == other
    end
   
    # Compute the hash key.
    def hash
      return name.hash ^ direction.hash ^ lhs.hash ^ rhs.hash
    end

    # Utility function to detect scalar vector port.
    # @return [Boolean] true if this is a scalar port else vector.
    # @note A port is scalar if lhs and rhs are both 0.
    def scalar?
      lhs == 0  and rhs == 0
    end

    # Utility function to return the width of the port
    # @return [Integer] Width of the port
    def width
      (lhs > rhs) ? lhs - rhs + 1 : rhs - lhs + 1
    end

    # Utility routine to return the port declaration 
    # @return [String] 
    def type
      if direction == "output" and width == 1
        return "logic"
      elsif direction == "output"
        return "logic [#{lhs}:#{rhs}]"
      elsif direction == "input" and not scalar? 
        return "[#{lhs}:#{rhs}]"
      else
        return ""
      end
    end

  end
end
