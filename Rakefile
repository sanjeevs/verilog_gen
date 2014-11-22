require "bundler/gem_tasks"
require "cucumber/rake/task"

Cucumber::Rake::Task.new('vscan_test') do |task|
  task.cucumber_opts = ["-r features", "features/vscan", " --tags ~@wip", 
                        "--tags ~@jsd"]
end

Cucumber::Rake::Task.new('vscan_jsd') do |task|
  task.cucumber_opts = ["-r features", "features/vscan", " --tags @jsd"]
end

Cucumber::Rake::Task.new('vscan_wip') do |task|
  task.cucumber_opts = ["-r features", "features/vscan", " --tags @wip"]
end
