require "bundler/gem_tasks"

require "rspec/core/rake_task"
RSpec::Core::RakeTask.new("spec")

task :pry do
  system "pry -I lib -r calvin -e 'include Calvin'"
end
task :default => :pry
