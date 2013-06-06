#!/usr/bin/env ruby
# -*- encoding: utf-8 -*-
#
# Author:: HIGUCHI Daisuke (<d-higuchi@creationline.com>)
#
# Copyright (C) 2013, HIGUCHI Daisuke
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
  rspec_path = RbConfig::CONFIG['bindir'] + '/rspec'
  if FileTest.executable? rspec_path
    t.rspec_path = rspec_path
  end
  t.ruby_opts = "-I#{base_path}"
  t.pattern = "#{base_path}/**/*_spec.rb"
end
Rake::Task["spec"].invoke
