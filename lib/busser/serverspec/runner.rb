#!/usr/bin/env ruby
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

require 'rake'
require 'rspec/core/rake_task'
require 'rbconfig'

base_path = File.expand_path(ARGV.shift)

RSpec::Core::RakeTask.new(:spec) do |t|
  candidate_bindirs = []
  # Current Ruby's default bindir
  candidate_bindirs << RbConfig::CONFIG['bindir']
  # Search all Gem paths bindirs
  candidate_bindirs << Gem.paths.path.map do |gem_path|
    File.join(gem_path, 'bin')
  end

  candidate_rspec_bins = candidate_bindirs.flatten.map do |bin_dir|
    File.join(bin_dir, 'rspec')
  end

  rspec_bin = candidate_rspec_bins.find do |candidate_rspec_bin|
    FileTest.exist?(candidate_rspec_bin) &&
      FileTest.executable?(candidate_rspec_bin)
  end

  t.rspec_path = rspec_bin if rspec_bin
  t.rspec_opts = [
    '--color',
    '--format documentation',
    "--default-path #{base_path}",
  ]
  t.ruby_opts = "-I#{base_path}"
  t.pattern = "#{base_path}/**/*_spec.rb"
end
begin
  Rake::Task['spec'].invoke
rescue RuntimeError
  exit 1
end
