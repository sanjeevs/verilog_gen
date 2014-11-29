# Wrapper routines to import design into ruby.

module VerilogGen
  # Return the created class for subsequent access.
  @@verilog_leaf_created = {}

  # Invoke vscan to create the leaf proxy.
  # @param [String] Class name of hdl leaf.
  # @param [Hash] parameter to pass to vscan.
  # @param file_name [Hash] name of the rtl file.
  # @return Hdl module class.
  # @note
  # Once a class is created then subsequent access will return prev value.
  def self.leaf(klass, params = {})
    options = { parameter: "", file_name: klass.snakecase + ".v" }
    params.each do |key, value|
      raise ArgumentError, "invalid valid value of leaf '#{key}'" \
        unless options.key? key
      options[key] = params[key]
    end
      
    key = klass + options[:parameter]
    unless @@verilog_leaf_created.key?(key)
      puts "Running vscan #{options[:parameter]} -class #{klass} #{options[:file_name]}"
      output = `vscan #{options[:parameter]} -class #{klass} \
                                            #{options[:file_name]}`
      eval output, binding, __FILE__, __LINE__
      @@verilog_leaf_created[key] = Object.const_get("VerilogGen::#{klass}")
    end
    @@verilog_leaf_created[key]
  end
end

