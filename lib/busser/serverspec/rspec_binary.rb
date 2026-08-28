#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require "rbconfig" unless defined?(RbConfig)

module Busser
  module Serverspec
    # Locates the rspec executable to run the suite with.
    #
    # The machine under test may have several Ruby installations and several
    # gem paths, and RSpec::Core::RakeTask would otherwise just shell out to
    # whatever `rspec` is on PATH -- which may belong to a different Ruby than
    # the one Busser installed serverspec into.
    #
    # This lives apart from runner.rb because that file is a script: requiring
    # it runs the suite.
    module RspecBinary
      module_function

      # Directories that might hold an rspec executable, most specific first.
      #
      # @param gem_paths [Array<String>] gem paths to search, defaulting to the
      #   current RubyGems configuration
      # @param ruby_bindir [String] the running Ruby's bindir; injectable so
      #   tests do not depend on what the host Ruby happens to have installed
      # @return [Array<String>] candidate bin directories
      def candidate_bindirs(gem_paths = Gem.paths.path, ruby_bindir = RbConfig::CONFIG["bindir"])
        [ruby_bindir] + gem_paths.map { |p| File.join(p, "bin") }
      end

      # The first candidate that exists and is executable.
      #
      # @param gem_paths [Array<String>] gem paths to search
      # @param ruby_bindir [String] the running Ruby's bindir
      # @return [String, nil] path to rspec, or nil to let the caller fall back
      #   to whatever is on PATH
      def find(gem_paths = Gem.paths.path, ruby_bindir = RbConfig::CONFIG["bindir"])
        candidate_bindirs(gem_paths, ruby_bindir)
          .map { |dir| File.join(dir, "rspec") }
          .find { |bin| File.exist?(bin) && File.executable?(bin) }
      end
    end
  end
end
