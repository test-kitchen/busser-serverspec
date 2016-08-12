# You should use Kitchen::Verifier::Shell + Serverspec

## 0.5.10 2016-08-12

* use container-based test at travis-ci.
* Make rake and rspec/core runtime deps
  merge pull-req by John Keiser <john@johnkeiser.com>, thanks.
* Pin versions of aruba and cucumber
  inspired by test-kitchen/busser-cucumber@cd3e6b3 by Peter Gallagher, thanks.

## 0.5.9 2016-01-22

* Fix frozen string issue when checking Ruby version
  merge pull-req by Joe Friedl <jfriedl@digitalocean.com>, thanks.

## 0.5.8 / 2016-01-22, 0.6.0 / 2016-01-18 (yanked 2016-02-22)

* Install net-ssh < 2.10 for ruby < 2.0.
  merge pull-req by Bill Ruddock <bill.ruddock@gmail.com>, thanks.

## 0.5.7 / 2015-06-01

* use RbConfig instead of obsolete and deprecated Config, closes #29
  suggested by Jörg Herzinger <joerg.herzinger@oiml.at>, thanks.

## 0.5.6 / 2015-04-27

* Run bundle with explicit path to ruby bin, closes #27
  merge pull-req by Simon Detheridge <simon@widgit.com>, thanks.

## 0.5.5 / 2015-04-02

* use File::PATH_SEPARATOR to join ENV PATH. closes #24
  suggested by Jacob McCann <jmccann.git@gmail.com>, thanks.

## 0.5.4 / 2015-03-30

* add the config bindir as well.
  merge pull-req by Noah Kantrowitz <noah@coderanger.net>. thanks.

## 0.5.3 / 2014-10-17

* make private working methods, closes #18

## 0.5.2 / 2014-10-16

* reset gems db

## 0.5.1 / 2014-10-16

* move Gemfile process from postinstall to test.

## 0.5.0 / 2014-10-16

* enable to specify serverspec version in Gemfile, closes #16
* add 'log_switch', '~> 0.3.0', ref: turboladen/tailor#160
* drop ruby 1.9.2 test, because mime-types 2.4.2 does not support ruby 1.9.2.

## 0.4.0 / 2014-10-06

* add --default-path for RSpec 3, closes #15
* bump up version number (0.3: load Gemfile, 0.4: serverspec v2).

## 0.2.8 / 2014-10-05

* update for serverspec v2, closes #13

## 0.2.7 / 2014-09-24

* support loading Gemfile. closes #12

## 0.2.6 / 2014-01-25

* add globbing pattern note for frequency asked test failure.
* update links for moving to test-kitchen organization.
* update copyright.

## 0.2.5 / 2013-11-14

* issue #5: Added --color and --format documentation rspec options
  merge pull-req by Kannan Manickam <kannan@rightscale.com>. thanks.

## 0.2.4 / 2013-11-01

* issue #4: Search all GEM_PATH values for `rspec` bin.
  merge pull-req by Seth Chisamore <schisamo@opscode.com>. thanks.

## 0.2.3 / 2013-07-10

* issue #2: remove tight dependency of serverspec. thanks to rteabeault.

## 0.2.2 / 2013-07-09

* issue #2: remove dependency rspec.

## 0.2.1 / 2013-06-18

* fix silly exit value.

## 0.2.0 / 2013-06-18

* issue #1: do not print full backtrace if serverspec test failure.

## 0.1.1 / 2013-06-06

* add cucumber test and fix related things

## 0.1.0 / 2013-05-22

* Initial release
