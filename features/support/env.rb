require 'pathname'
root = Pathname.new(__FILE__).parent.parent.parent

ENV['PATH'] = "#{root.join('bin').to_s}#{File::PATH_SEPARATOR}#{ENV['PATH']}"
puts ENV['PATH']
