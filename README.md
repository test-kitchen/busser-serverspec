# Busser::RunnerPlugin::Serverspec


A Busser runner plugin for Serverspec

## Status

This Gem has now been archived. No active maintainers have come forward in the past 5 years and the original maintainer has since pulled the plugin.

We recommend moving to a maintained project for similar functionality or building and running the Gem yourself.

## Installation and Setup

Put this into your `kitchen.yml`:

```yaml
verifier:
  name: busser
```

You may also look at the Busser [plugin usage][plugin_usage] page.

## Usage

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

## Note

### File Matching

The globbing pattern to match files is `"serverspec/*/*_spec.rb"`.
You need to use `"_spec.rb"` (underscore), not `"-spec.rb"` (minus).

### Specify Serverspec version

If you have to specify the Serverspec version, you can use Gemfile. Example Gemfile:

```Gemfile
source 'https://rubygems.org'
gem 'serverspec', '< 2.0'
```

### Serverspec backend

It runs on a target server for testing after ssh log in it.
So you need to specify `set :backend, :exec` not `set :backend, :ssh` (Serverspec v2).
If you use Serverspec v1, you must specify `include SpecInfra::Helper::Exec` not `include SpecInfra::Helper::Ssh`.

## Authors

Created and maintained by [HIGUCHI Daisuke][author] (<d-higuchi@creationline.com>)

## License

Apache 2.0 (see [LICENSE][license])

[author]:           https://github.com/cl-lab-k
[license]:          https://github.com/test-kitchen/busser-serverspec/blob/master/LICENSE
[plugin_usage]:     https://kitchen.ci/docs/verifiers/serverspec/
