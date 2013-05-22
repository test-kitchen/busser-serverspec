Feature: Test command
  In order to run tests written with serverspec
  As a user of Busser
  I want my tests to run when the serverspec runner plugin is installed

  Background:
    Given a test BUSSER_ROOT directory named "busser-serverspec-test"
    When I successfully run `busser plugin install busser-serverspec --force-postinstall`
    Given a suite directory named "serverspec"

  Scenario: A passing test suite
    Given a file in suite "serverspec" named "<YOUR_FILE>" with:
    """
    TEST FILE CONTENT

    A good test might be a simple passing statement
    """
    When I run `busser test serverspec`
    Then I should verify some output for the serverspec plugin
    And the exit status should be 0

  Scenario: A failing test suite
    Given a file in suite "serverspec" named "<YOUR_FILE>" with:
    """
    TEST FILE CONTENT

    A good test might be a failing test case, raised exception, etc.
    """
    When I run `busser test serverspec`
    Then I should verify some output for the serverspec plugin
    And the exit status should not be 0
