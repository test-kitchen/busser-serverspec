require "bundler/gem_tasks"
require "rake/testtask"
Rake::TestTask.new(:unit) do |t|
  t.libs.push "lib"
  t.test_files = FileList["spec/**/*_spec.rb"]
  t.verbose = true
end

require "cucumber/rake/task"

Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = ["features", "--format progress", "--fail-fast"]
end

desc "Run all test suites"
task test: %i{unit features}

task default: [:test]
