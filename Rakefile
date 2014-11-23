require "bundler/gem_tasks"
require "cucumber/rake/task"
require "rspec/core/rake_task"

# Passing vscan tests. 
# Ignore all work in progress (wip) and those under debug (jsd)
Cucumber::Rake::Task.new('vscan_test') do |task|
  task.cucumber_opts = ["-r features", "features/vscan", " --tags ~@wip", 
                        "--tags ~@jsd"]
end

# Run the vscan tests for jon's debug.
Cucumber::Rake::Task.new('vscan_jsd') do |task|
  task.cucumber_opts = ["-r features", "features/vscan", " --tags @jsd"]
end

# Run the vscan tests which are not yet implemented.
Cucumber::Rake::Task.new('vscan_wip') do |task|
  task.cucumber_opts = ["-r features", "features/vscan", " --tags @wip"]
end

# Run the rspec tests.
RSpec::Core::RakeTask.new(:spec)
