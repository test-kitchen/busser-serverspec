# -*- encoding: utf-8 -*-
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

require 'busser/runner_plugin'
require 'rubygems/dependency_installer'

# A Busser runner plugin for Serverspec.
#
# @author HIGUCHI Daisuke <d-higuchi@creationline.com>
#
class Busser::RunnerPlugin::Serverspec < Busser::RunnerPlugin::Base
  postinstall do
    install_gem('bundler')
  end

  def test
    run_bundle_install
    install_serverspec

    runner = File.join(File.dirname(__FILE__), %w{.. serverspec runner.rb})
    run_ruby_script!("#{runner} #{suite_path('serverspec').to_s}")
  end

  private

  def run_bundle_install
    # Referred from busser-shindo
    gemfile_path = File.join(suite_path, 'serverspec', 'Gemfile')
    if File.exists?(gemfile_path)
      # Bundle install local completes quickly if the gems are already found
      # locally it fails if it needs to talk to the internet. The || below is
      # the fallback to the internet-enabled version. It's a speed optimization.
      banner('Bundle Installing..')
      ENV['PATH'] = [ENV['PATH'], Gem.bindir, RbConfig::CONFIG['bindir']].join(File::PATH_SEPARATOR)
      bundle_exec = "#{File.join(RbConfig::CONFIG['bindir'], 'ruby')} " +
        "#{File.join(Gem.bindir, 'bundle')} install --gemfile #{gemfile_path}"
      run("#{bundle_exec} --local || #{bundle_exec}")
    end
  end

  def install_serverspec
    Gem::Specification.reset
    if Array(Gem::Specification.find_all_by_name('serverspec')).size == 0
      if Gem::Version.new(RUBY_VERSION.dup) < Gem::Version.new('2.0')
        banner('Installing net-ssh < 2.10')
        install_gem('net-ssh', '< 2.10')
      end
      banner('Installing Serverspec..')
      spec = install_gem('serverspec')
      banner "serverspec installed (version #{spec.version})"
    end
  end
end
