Feature: Plugin list command
  In order to use this plugin
  As a user of Busser
  I want to see this plugin in the 'busser plugin list' command

  Scenario: Plugin appears in plugin list command
    When I successfully run `busser plugin list`
    Then the output should match /^serverspec\b/
