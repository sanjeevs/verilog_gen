require "bundler/gem_tasks"
require "cucumber/rake/task"
require "rspec/core/rake_task"
require 'yard'

# Generate documentation
YARD::Rake::YardocTask.new

# Passing vscan tests. 
# Ignore all work in progress (wip) and those under debug (jsd)
Cucumber::Rake::Task.new('vscan_test') do |task|
  task.cucumber_opts = ["-r features", "features/vscan", " --tags ~@wip"]
end

# Run the vscan tests which are not yet implemented.
Cucumber::Rake::Task.new('vscan_wip') do |task|
  task.cucumber_opts = ["-r features", "features/vscan", " --tags @wip"]
end

# Run the rspec tests.
RSpec::Core::RakeTask.new(:spec)
