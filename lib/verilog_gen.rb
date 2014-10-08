require "verilog_gen/version"
require "verilog_gen/port"

module VerilogGen

  def self.main(options, hdl_files)
    hdl_files.each do |hdl_file|
      eval(File.open(hdl_file).read)
    end
  end

end
