require "bundler/gem_tasks"
require "cucumber/rake/task"

Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = ["features", "--format progress", "--fail-fast"]
end

desc "Run all test suites"
task test: [:features]

task default: [:test]
