# Contributing to busser-serverspec

Thanks for taking the time to contribute. This document covers how to get the
project running locally, how to check your work before opening a pull request,
and the commit convention releases depend on.

## Getting set up

This plugin requires **Ruby 3.2 or newer**. Clone the repository and install the
development dependencies:

```bash
git clone https://github.com/test-kitchen/busser-serverspec.git
cd busser-serverspec
bundle install
```

## Running the tests

`rake` runs the whole suite:

```bash
bundle exec rake test
```

The tests are [cucumber](https://cucumber.io) features in `features/`. They
drive the real `busser` executable through
[aruba](https://github.com/cucumber/aruba) rather than calling the plugin's
classes, so they cover it end to end: install the plugin into a throwaway
Busser root, write a suite, run it, and check what came out. The step
definitions they use are published by busser itself, in `lib/busser/cucumber.rb`.

### How the feature sandbox works

Features that install the plugin sandbox `GEM_HOME` into a temporary directory
and strip bundler out of the environment, so a run never installs a gem into
your bundle. Two details matter if you add or change one:

* **Do not reintroduce bundler variables.** RubyGems re-requires
  `bundler/setup` whenever `BUNDLER_SETUP` is present, and bundler then resets
  `Gem.dir` to the bundle. Plugins install into `vendor/bundle` instead of the
  sandbox, and the assertions that look in `GEM_HOME` fail. The
  `a non bundler environment` step exists to clear this.
* **The plugin is installed from the working tree.** With bundler out of the
  way, `busser plugin install` would fetch the last release from RubyGems and
  run *its* postinstall — so the suite would pass on code that is not in your
  branch. The `this plugin is installed from the working tree` step builds the
  gem from the gemspec and installs it into the sandbox first, which is what
  makes the features test your change.

## Linting

CI runs three linters, all of which you can run locally:

```bash
bundle exec cookstyle --chefstyle   # Ruby
yamllint --strict .                 # YAML
markdownlint-cli2 "**/*.md" "!**/CHANGELOG*.md"
```

## Commit messages

This project uses [Conventional Commits](https://www.conventionalcommits.org).
Releases are automated, and the commit subject on `main` is what decides the
next version number and what appears in the changelog.

Pull requests are **squash merged, so the pull request title becomes that
subject**. A CI check enforces the format on the title; the individual commits
on your branch are not checked.

| Prefix | Effect on the next release |
| --- | --- |
| `fix:` | Patch version bump |
| `feat:` | Minor version bump |
| `feat!:`, or a `BREAKING CHANGE:` footer | Minor bump, until this gem reaches 1.0 |
| `chore:`, `docs:`, `ci:`, `test:`, `refactor:` | No release |

For example:

```text
fix: install the plugin into GEM_HOME rather than the bundle
feat: support a Gemfile alongside the suite
ci: pin the shared workflow to a release
```

## Opening a pull request

1. Fork the repository and create a branch for your change.
2. Add or update tests. A bug fix should come with a test that fails without it.
3. Run `bundle exec rake test` and the linters above.
4. Open a pull request with a Conventional Commits title.

## Releases

Releases are handled by
[release-please](https://github.com/googleapis/release-please). It watches
commits landing on `main` and keeps a release pull request open with the next
version number and the accumulated changelog. Merging that pull request tags the
release and publishes the gem to RubyGems and GitHub Packages.

Maintainers do not bump `lib/busser/serverspec/version.rb` or edit
`CHANGELOG.md` by hand; release-please owns both files. This gem is still pre-1.0, so
`bump-minor-pre-major` is set and a breaking change takes the minor rather than
graduating it to 1.0.
