# <a name="title"></a> Busser::RunnerPlugin::Serverspec

[![Gem Version](https://badge.fury.io/rb/busser-serverspec.svg)](http://rubygems.org/gems/busser-serverspec) [![Build Status](https://secure.travis-ci.org/test-kitchen/busser-serverspec.svg?branch=master)](https://travis-ci.org/test-kitchen/busser-serverspec) [![Code Climate](https://codeclimate.com/github/cl-lab-k/busser-serverspec.svg)](https://codeclimate.com/github/cl-lab-k/busser-serverspec)

A Busser runner plugin for Serverspec

## Status

This Gem has now been archived. No active maintainers have come forward in the past 5 years and the original maintainer has since pulled the plugin. 

We recommend moving to a maintained project for similar functionality or building and running the Gem yourself. 

## <a name="installation"></a> Installation and Setup

Put this into your `kitchen.yml`:
```
verifier:
  name: busser
```

You may also look at the Busser [plugin usage][plugin_usage] page.

## <a name="usage"></a> Usage

Please put test files into [COOKBOOK]/test/integration/[SUITES]/serverspec/

```cookbook
`-- test
    `-- integration
        `-- default
            `-- serverspec
                |-- Gemfile
                |-- localhost
                |   `-- httpd_spec.rb
                `-- spec_helper.rb
```

`Gemfile` is optional. You can specify installing Serverspec version and install the gems you need.

## <a name="note"></a> Note

### <a name="spec"></a> File Matching

The globbing pattern to match files is `"serverspec/*/*_spec.rb"`.
You need to use `"_spec.rb"` (underscore), not `"-spec.rb"` (minus).

### <a name="serverspec1"></a> Specify Serverspec version

If you have to specify the Serverspec version, you can use Gemfile. Example Gemfile:

```Gemfile
source 'https://rubygems.org'
gem 'serverspec', '< 2.0'
```

### <a name="backend"></a> Serverspec backend

It runs on a target server for testing after ssh log in it.
So you need to specify `set :backend, :exec` not `set :backend, :ssh` (Serverspec v2).
If you use Serverspec v1, you must specify `include SpecInfra::Helper::Exec` not `include SpecInfra::Helper::Ssh`.

## <a name="authors"></a> Authors

Created and maintained by [HIGUCHI Daisuke][author] (<d-higuchi@creationline.com>)

## <a name="license"></a> License

Apache 2.0 (see [LICENSE][license])

[author]:           https://github.com/cl-lab-k
[issues]:           https://github.com/test-kitchen/busser-serverspec/issues
[license]:          https://github.com/test-kitchen/busser-serverspec/blob/master/LICENSE
[repo]:             https://github.com/test-kitchen/busser-serverspec
[plugin_usage]:     https://kitchen.ci/docs/verifiers/serverspec/
