require "verilog_gen/version"
require "verilog_gen/port"

module VerilogGen

  def self.main(options, hdl_modules)
    hdl_modules.each do |hdl_design|
      eval(File.open(hdl_design).read)
    end
  end

end
