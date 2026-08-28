#
# Author:: HIGUCHI Daisuke (<d-higuchi@creationline.com>)
#
# Copyright (C) 2013-2014, HIGUCHI Daisuke
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

require "busser/runner_plugin"
require "rubygems/dependency_installer"

# A Busser runner plugin for Serverspec.
#
# @author HIGUCHI Daisuke <d-higuchi@creationline.com>
#
class Busser::RunnerPlugin::Serverspec < Busser::RunnerPlugin::Base
  # Installs bundler onto the machine under test. Serverspec itself is left
  # until #test, so a suite that pins its own version in a Gemfile is not
  # made to download a second copy first.
  postinstall do
    install_gem("bundler")
  end

  # Runs the suite's specs, installing the suite's own gems and serverspec
  # first if they are not already present.
  #
  # @return [void]
  def test
    run_bundle_install
    install_serverspec

    runner = File.join(File.dirname(__FILE__), %w{.. serverspec runner.rb})
    run_ruby_script!("#{runner} #{suite_path("serverspec")}")
  end

  private

  # Installs the suite's own gems, if it ships a Gemfile. This is how a suite
  # pins a particular serverspec version.
  #
  # @return [nil] if the suite has no Gemfile
  def run_bundle_install
    # Referred from busser-shindo
    gemfile_path = File.join(suite_path, "serverspec", "Gemfile")
    if File.exist?(gemfile_path)
      # Bundle install local completes quickly if the gems are already found
      # locally it fails if it needs to talk to the internet. The || below is
      # the fallback to the internet-enabled version. It's a speed optimization.
      banner("Bundle Installing..")
      ENV["PATH"] = [ENV["PATH"], Gem.bindir, RbConfig::CONFIG["bindir"]].join(File::PATH_SEPARATOR)
      bundle_exec = "#{File.join(RbConfig::CONFIG["bindir"], "ruby")} " +
        "#{File.join(Gem.bindir, "bundle")} install --gemfile #{gemfile_path}"
      run("#{bundle_exec} --local || #{bundle_exec}")
    end
  end

  # Installs serverspec unless some version is already available, so a version
  # pinned by the suite's own Gemfile is left alone.
  #
  # @return [void]
  def install_serverspec
    Gem::Specification.reset
    if Array(Gem::Specification.find_all_by_name("serverspec")).size == 0
      banner("Installing Serverspec..")
      spec = install_gem("serverspec", ">= 2.43")
      banner "serverspec installed (version #{spec.version})"
    end
  end
end
