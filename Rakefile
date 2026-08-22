require 'coveralls/rake/task'
require "bundler/gem_tasks"
require 'cucumber/rake/task'

Coveralls::RakeTask.new

Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = ['features', '-x', '--format progress']
end

desc "Run all test suites"
task :test => [:features]



desc "Display LOC stats"
task :stats do
  puts "\n## Production Code Stats"
  sh "countloc -r lib"
  puts "\n## Test Code Stats"
  sh "countloc -r features"
end

desc "Run all quality tasks"
task :quality => [:stats]

task :default => [:test, :quality, 'coveralls:push']
