module VerilogGen
  # Model of a verilog port.
  class Port
    
    @@DEFAULT_PARAMS = {
                       :name => "", 
                       :direction => "input", 
                       :lhs => 0, 
                       :rhs => 0,
                       :type => "wire",
                       :packed => "",
                       :unpacked => ""
                      }

    # Construct a port.
    # @param [Hash] params properties of the port
    # @option params [String] :name name of the port
    # @option params [String] :direction By default input
    # @option params [Integer]:left By default 0 
    # @option params [Integer] right hand digit. By default 0.
    # @note If lhs and rhs are 0 then it is a scalar port else vector type.
    def initialize(name, params = {})
      @@DEFAULT_PARAMS.each do |key, value|
        instance_variable_set("@#{key}", value)
        self.class.send(:attr_reader, key.to_s)
      end

      @name = name

      params.each do |key, value|
        raise ArgumentError, 
          "invalid value of port field '#{key}' with '#{value}'" \
           unless @@DEFAULT_PARAMS.has_key? key
        instance_variable_set("@#{key}", value)
      end

      #Enumeration checking.
      raise ArgumentError, "direction '#{direction}' is not valid value" \
                        unless @direction == "input" or @direction == "output"\
                          or @direction == "inout"

      # FIXME: Hack lhs and rhs
      unless @packed == ""
        m = /\[\s*(\d+)\s*:\s*(\d+)\s*\]/.match @packed
        @lhs = m.captures[0].to_i
        @rhs = m.captures[1].to_i
      end 
    end

    def clone(params = {})
      p = Port.new(name, direction: @direction, lhs: @lhs, rhs: @rhs, type: @type,
                   packed: @packed, unpacked: @unpacked)
      
      params.each do |key, value|
        p.key = value
      end
      p
    end

    # Equaltiy of port
    # @param [Object] other port instance
    # @return [Boolean] comparion result
    def ==(other)
      return false unless other.instance_of?(self.class)
      name == other.name && direction == other.direction \
        && lhs == other.lhs && rhs == other.rhs
    end

    # Well behaved hash keys
    # @param [Object] other port instance
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

    def update_width(range)
      @lhs = range[0] 
      @rhs = range[1] 
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
