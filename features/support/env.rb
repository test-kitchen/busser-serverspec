require "fileutils" unless defined?(FileUtils)
require "rubygems/package"

require "aruba/cucumber"
require "busser/cucumber"

if ENV["COVERAGE"]
  require "simplecov"
  SimpleCov.command_name "features"
  SimpleCov.start
end

# aruba 2 dropped @aruba_timeout_seconds; setting it in a Before hook is a
# no-op, which quietly left these commands on aruba's 15 second default.
# Installing a plugin and its gems into a cold sandbox does not always fit.
Aruba.configure do |config|
  config.exit_timeout = 120
end

After do |s|
  # Tell Cucumber to quit after this scenario is done - if it failed.
  # This is useful to inspect the 'tmp/aruba' directory before any other
  # steps are executed and clear it out.
  Cucumber.wants_to_quit = true if s.failed?
end

# The sandboxed features shell out to `busser plugin install <this plugin>`, and
# two things have to hold for that to exercise this checkout:
#
#   * The child has to be free of bundler. RubyGems re-requires bundler/setup
#     whenever BUNDLER_SETUP is set, and bundler then resets Gem.dir to the
#     bundle, so busser installs into vendor/bundle rather than the sandboxed
#     GEM_HOME the features assert against. busser's "a non bundler environment"
#     step clears that, and has to run before the sandbox is set up.
#   * The plugin has to already be in that sandbox. Otherwise busser fetches the
#     last release from RubyGems and runs *its* postinstall, which means CI
#     silently tests the published gem instead of the code under review.
#
# So build the gem from the working tree and install it into the sandbox first.
Given(/^this plugin is installed from the working tree$/) do
  root = File.expand_path("../..", __dir__)
  package = nil

  begin
    Dir.chdir(root) do
      spec = Gem::Specification.load(Dir["*.gemspec"].first)
      package = Gem::Package.build(spec)

      # --ignore-dependencies keeps this from reaching the network: busser and
      # the rest are already resolvable through the GEM_PATH the sandbox step
      # leaves in place.
      installed = system(
        Gem.ruby, "-S", "gem", "install", "--local", "--no-document",
        "--ignore-dependencies", package, out: File::NULL
      )
      raise "could not install #{package} into #{ENV["GEM_HOME"]}" unless installed
    end
  ensure
    FileUtils.rm_f(File.join(root, package)) if package
  end
end
