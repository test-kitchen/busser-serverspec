require "bundler/gem_tasks"
require 'cucumber/rake/task'
require 'cane/rake_task'
require 'tailor/rake_task'

Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = ['features', '-x', '--format progress']
end

desc "Run all test suites"
task :test => [:features]

desc "Run cane to check quality metrics"
Cane::RakeTask.new do |cane|
  cane.canefile = './.cane'
end

Tailor::RakeTask.new

desc "Display LOC stats"
task :stats do
  puts "\n## Production Code Stats"
  sh "countloc -r lib"
  puts "\n## Test Code Stats"
  sh "countloc -r features"
end

desc "Run all quality tasks"
task :quality => [:cane, :tailor, :stats]

task :default => [:test, :quality]
