require "coveralls/rake/task"
require "bundler/gem_tasks"
require "cucumber/rake/task"

Coveralls::RakeTask.new

Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = ["features", "-x", "--format progress"]
end

desc "Run all test suites"
task test: [:features]

task default: [:test, "coveralls:push"]
