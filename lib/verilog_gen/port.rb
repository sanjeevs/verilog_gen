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
  end
end
