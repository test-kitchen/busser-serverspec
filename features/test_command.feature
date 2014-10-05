Feature: Test command
  In order to run tests written with serverspec
  As a user of Busser
  I want my tests to run when the serverspec runner plugin is installed

  Background:
    Given a test BUSSER_ROOT directory named "busser-serverspec-test"
    And a sandboxed GEM_HOME directory named "busser-serverspec-gem-home"
    When I successfully run `busser plugin install busser-serverspec --force-postinstall`
    Given a suite directory named "serverspec"

  Scenario: A passing test suite
    Given a file in suite "serverspec" named "localhost/default_spec.rb" with:
    """
    require 'serverspec'
    set :backend, :exec

    describe command( "echo 'hello'" ) do
      its(:exit_status) { should eq 0 }
      its(:stdout) { should eq "hello\n" }
    end
    """
    When I run `busser test serverspec`
    Then the output should contain:
    """
    2 examples, 0 failures
    """
    And the exit status should be 0

  Scenario: A failing test suite
    Given a file in suite "serverspec" named "localhost/default_spec.rb" with:
    """
    require 'serverspec'
    set :backend, :exec

    describe command( 'which uhoh-whatzit-called' ) do
      its(:exit_status) { should eq 0 }
    end
    """
    When I run `busser test serverspec`
    Then the output should contain:
    """
    1 example, 1 failure
    """
    And the exit status should not be 0
