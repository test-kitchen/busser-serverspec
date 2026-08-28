# busser-serverspec

[![Gem Version](https://badge.fury.io/rb/busser-serverspec.svg)](https://badge.fury.io/rb/busser-serverspec)

A [Busser](https://github.com/test-kitchen/busser) runner plugin that runs
[Serverspec](https://serverspec.org) tests as integration tests.

Busser installs Serverspec on the machine under test the first time a suite
runs, then executes the suite's `serverspec` directory against it. Because the
tests run on the machine itself, they use Serverspec's `exec` backend rather
than SSH.

## Status

This gem has been archived. No active maintainers have come forward in the past
five years and the original maintainer has since pulled the plugin.

We recommend moving to a maintained project for similar functionality, or
building and running the gem yourself. In particular,
[kitchen-verifier-shell](https://github.com/higanworks/kitchen-verifier-shell)
with Serverspec covers the same ground and is configured directly in your
`kitchen.yml`.

## Requirements

Ruby 3.2 or newer, and busser 0.9.0 or newer.

## Installation

Select the Busser verifier in your `kitchen.yml`:

```yaml
verifier:
  name: busser
```

Busser then installs the plugin for you when the suite runs. To install it by
hand:

```bash
busser plugin install busser-serverspec
```

## Usage

Put your specs in a subdirectory of the suite's `serverspec` directory:

```text
test
`-- integration
    `-- default              # suite name
        `-- serverspec
            |-- Gemfile          # optional
            |-- spec_helper.rb
            `-- localhost
                `-- httpd_spec.rb
```

Specs are collected recursively as `**/*_spec.rb`, so any depth works; the
`localhost/` directory above is convention, not a requirement. The separator is
an underscore — `_spec.rb`, not `-spec.rb`. The suite directory is also added to
the load path and set as RSpec's default path, so `require "spec_helper"` works
without a relative path.

```ruby
require "spec_helper"

describe command("echo hello") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should eq "hello\n" }
end
```

### Backend

The tests run on the machine under test, after Test Kitchen has logged in, so
the `exec` backend is the right one:

```ruby
require "serverspec"
set :backend, :exec
```

Do not use `set :backend, :ssh` — that would have Serverspec connect back out
over the network from a machine that is already the target.

### Pinning Serverspec

A `Gemfile` in the suite directory is `bundle install`ed before the run, which
is how you pin a particular Serverspec version:

```ruby
source "https://rubygems.org"

gem "serverspec", "~> 2.43"
```

Without one, the plugin installs Serverspec 2.43 or newer.

## Contributing

Bug reports and pull requests are welcome. See
[CONTRIBUTING.md](CONTRIBUTING.md) for how to set up the project, run the test
suite, and format your commits.

## License

Apache License 2.0. See [LICENSE](LICENSE).

Originally created by [HIGUCHI Daisuke](https://github.com/cl-lab-k).
