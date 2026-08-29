#!/usr/bin/env bash
# Installs this working tree into the Busser root the Test Kitchen verifier
# will use, so `kitchen verify` exercises the code on this branch rather than
# the last release from RubyGems.
#
# The verifier's install script skips its own install when `gem list` already
# shows what it wants, so putting things in place first is all that is needed.
# Two consequences to handle:
#
#   * It also has to install busser itself. That check is `grep "^busser"` with
#     no anchor at the end, so a plugin named busser-* satisfies it and busser
#     would otherwise never be installed at all.
#   * Skipping `busser plugin install` also skips the plugin's postinstall,
#     which is where a plugin installs the test framework it drives. So run the
#     postinstall here, which is what the verifier would have done.
set -euo pipefail

BUSSER_ROOT="${BUSSER_ROOT:-/tmp/busser-kitchen}"
gemspec="$(ls ./*.gemspec)"
gem_name="$(basename "${gemspec}" .gemspec)"

install_opts=(
  --install-dir "${BUSSER_ROOT}/gems"
  --bindir "${BUSSER_ROOT}/bin"
  --no-document
)

mkdir -p "${BUSSER_ROOT}/gems"

gem build "${gemspec}" --output "${BUSSER_ROOT}/${gem_name}.gem" >/dev/null

if [ "${gem_name}" = "busser" ]; then
  # No --local: a plugin's runtime dependencies are things its runner needs on
  # the machine under test, and they have to be fetched into the Busser root
  # like everything else.
  gem install "${BUSSER_ROOT}/${gem_name}.gem" "${install_opts[@]}" >/dev/null
else
  gem install busser "${install_opts[@]}" >/dev/null
  # Not --ignore-dependencies: a plugin's runtime dependencies are things its
  # runner needs on the machine under test, and they have to be in the Busser
  # root like everything else.
  # No --local: a plugin's runtime dependencies are things its runner needs on
  # the machine under test, and they have to be fetched into the Busser root
  # like everything else.
  gem install "${BUSSER_ROOT}/${gem_name}.gem" "${install_opts[@]}" >/dev/null

  # The same environment the verifier exports, so the framework this plugin
  # installs lands in the Busser root rather than the ambient gem home.
  BUSSER_ROOT="${BUSSER_ROOT}" \
    GEM_HOME="${BUSSER_ROOT}/gems" \
    GEM_PATH="${BUSSER_ROOT}/gems" \
    "${BUSSER_ROOT}/bin/busser" plugin install "${gem_name}" --force-postinstall
fi

echo "pre-installed ${gem_name} from the working tree into ${BUSSER_ROOT}"
