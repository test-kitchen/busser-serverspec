require_relative "../../spec_helper"

require "rbconfig"
require "shellwords"
require "busser/runner_plugin/serverspec"

describe Busser::RunnerPlugin::Serverspec do
  describe ".runner_command" do
    it "runs the runner against the suite" do
      cmd = Busser::RunnerPlugin::Serverspec.runner_command("/gems/runner.rb",
        "/opt/busser/suites/serverspec")

      _(Shellwords.split(cmd)).must_equal ["/gems/runner.rb", "/opt/busser/suites/serverspec"]
    end

    # BUSSER_ROOT is chosen by the caller. Unquoted, a space split the path and
    # the runner was handed a fragment as its base path.
    it "quotes a suite path containing spaces" do
      cmd = Busser::RunnerPlugin::Serverspec.runner_command("/a/runner.rb",
        "/tmp/my tests/serverspec")

      _(Shellwords.split(cmd)).must_equal ["/a/runner.rb", "/tmp/my tests/serverspec"]
    end

    it "accepts Pathname arguments" do
      cmd = Busser::RunnerPlugin::Serverspec.runner_command(Pathname.new("/a/r.rb"),
        Pathname.new("/b/serverspec"))

      _(Shellwords.split(cmd)).must_equal ["/a/r.rb", "/b/serverspec"]
    end
  end

  describe ".bundle_install_command" do
    let(:cmd) { Busser::RunnerPlugin::Serverspec.bundle_install_command("/suite/Gemfile") }

    it "invokes bundler through the running Ruby rather than PATH" do
      first, second = Shellwords.split(cmd).first(2)

      _(first).must_equal File.join(RbConfig::CONFIG["bindir"], "ruby")
      _(second).must_equal File.join(Gem.bindir, "bundle")
    end

    it "names the suite's Gemfile explicitly" do
      _(Shellwords.split(cmd)).must_include "/suite/Gemfile"
    end

    it "falls back from the local attempt to a networked one" do
      _(cmd).must_include "--local || "
      _(cmd.scan("--gemfile").length).must_equal 2
    end

    it "quotes a Gemfile path containing spaces" do
      cmd = Busser::RunnerPlugin::Serverspec.bundle_install_command("/tmp/my tests/Gemfile")

      _(Shellwords.split(cmd.split(" || ").first)).must_include "/tmp/my tests/Gemfile"
    end
  end
end
