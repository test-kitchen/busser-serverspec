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

# yard lives in the :development group, which CI omits when it runs the tests.
# Requiring it unconditionally would make `rake test` fail there, so the real
# task is only defined when yard is installed and a stub explains its absence
# otherwise. Nothing in CI gates on documentation.
begin
  require "yard"

  YARD::Rake::YardocTask.new(:doc) do |t|
    t.files = ["lib/**/*.rb"]
    t.options = ["--output-dir", "doc", "--markup", "markdown"]
  end
rescue LoadError
  desc "Generate YARD documentation (install the development group first)"
  task :doc do
    abort "yard is not available. Run `bundle install --with development` first."
  end
end

desc "Run all test suites"
task test: %i{unit features}

task default: [:test]
