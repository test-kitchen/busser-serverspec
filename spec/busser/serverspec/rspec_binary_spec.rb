require_relative "../../spec_helper"

require "fileutils"
require "tmpdir"
require "busser/serverspec/rspec_binary"

describe Busser::Serverspec::RspecBinary do
  def bindir_with_rspec(root, executable: true)
    bin = File.join(root, "bin")
    FileUtils.mkdir_p(bin)
    path = File.join(bin, "rspec")
    File.write(path, "#!/bin/sh\n")
    File.chmod(executable ? 0o755 : 0o644, path)
    path
  end

  describe ".candidate_bindirs" do
    it "looks at the running Ruby's bindir before any gem path" do
      dirs = Busser::Serverspec::RspecBinary.candidate_bindirs(["/gems/a"])
      _(dirs.first).must_equal RbConfig::CONFIG["bindir"]
    end

    it "appends bin to each gem path" do
      dirs = Busser::Serverspec::RspecBinary.candidate_bindirs(["/gems/a", "/gems/b"])
      _(dirs.last(2)).must_equal ["/gems/a/bin", "/gems/b/bin"]
    end

    it "copes with no gem paths at all" do
      _(Busser::Serverspec::RspecBinary.candidate_bindirs([]))
        .must_equal [RbConfig::CONFIG["bindir"]]
    end
  end

  describe ".find" do
    # An empty stand-in for the running Ruby's bindir, so these do not depend on
    # whether the host Ruby happens to have an rspec next to it.
    let(:no_ruby_bin) { Dir.mktmpdir }
    after { FileUtils.remove_entry(no_ruby_bin) if File.directory?(no_ruby_bin) }
    it "returns the rspec in the first gem path that has one" do
      Dir.mktmpdir do |a|
        Dir.mktmpdir do |b|
          bindir_with_rspec(a)
          bindir_with_rspec(b)
          _(Busser::Serverspec::RspecBinary.find([a, b], no_ruby_bin)).must_equal File.join(a, "bin", "rspec")
        end
      end
    end

    it "skips a gem path with no rspec" do
      Dir.mktmpdir do |empty|
        Dir.mktmpdir do |real|
          bindir_with_rspec(real)
          _(Busser::Serverspec::RspecBinary.find([empty, real], no_ruby_bin))
            .must_equal File.join(real, "bin", "rspec")
        end
      end
    end

    # A non-executable file here would be handed to Rake as rspec_path and the
    # run would die with a permission error rather than falling back to PATH.
    it "skips a file that exists but is not executable" do
      Dir.mktmpdir do |a|
        Dir.mktmpdir do |b|
          bindir_with_rspec(a, executable: false)
          bindir_with_rspec(b)
          _(Busser::Serverspec::RspecBinary.find([a, b], no_ruby_bin)).must_equal File.join(b, "bin", "rspec")
        end
      end
    end

    # nil is meaningful: the caller leaves rspec_path unset and Rake falls back
    # to whatever rspec is on PATH.
    it "returns nil when nothing is found, rather than a bogus path" do
      Dir.mktmpdir { |dir| _(Busser::Serverspec::RspecBinary.find([dir], no_ruby_bin)).must_be_nil }
    end
  end
end
