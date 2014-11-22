require "bundler/gem_tasks"
require "cucumber/rake/task"

Cucumber::Rake::Task.new('test_vscan') do |task|
  task.cucumber_opts = ["-r features", "features/vscan", " --tags ~@wip"]
end

Cucumber::Rake::Task.new('jsd_vscan') do |task|
  task.cucumber_opts = ["-r features", "features/vscan", " --tags @jsd"]
end
