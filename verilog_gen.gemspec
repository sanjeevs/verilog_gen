# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'verilog_gen/version'

Gem::Specification.new do |spec|
  spec.name          = "verilog_gen"
  spec.version       = VerilogGen::VERSION
  spec.authors       = ["sanjeev singh"]
  spec.email         = ["snjvsingh123@gmail.com"]
  spec.summary       = %q{Generate verilog RTL hierarchy.}
  spec.description   = %q{Writing portable RTL design in verilog is challenging due to limitations of verilog language. Hence would like to write the leaf modules of the design in verilog but use Ruby to stich different views of the design.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end
