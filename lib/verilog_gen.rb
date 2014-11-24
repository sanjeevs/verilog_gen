require 'erb'
require "verilog_gen/version"
require "verilog_gen/port"
require "verilog_gen/pin"
require "templates/helpers"
require "verilog_gen/hdl_module"
require "verilog_gen/string"

module VerilogGen

  def self.main(options, hdl_files)
    hdl_files.each do |hdl_file|
      eval(File.open(hdl_file).read)
    end
    top_module_name = options[:top_module_name]
    top_module = top_module_name.new("#{top_module_name}")
    top_module.build
    top_module.connect
    output =  top_module.render("#{options[:default_template]}")
    File.open("#{options[:output_filename]}") do |fh|
      fh.write(output)
    end
  end

end
