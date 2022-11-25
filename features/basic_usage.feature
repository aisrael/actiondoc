Feature: Basic Usage
  Background:
    Given an executable named "generate" with:
      """
      #!/bin/bash
      ruby ../../generate.rb $@
      """

  Scenario: Version
    When I run `./generate --version`
    Then the output should contain:
      """
      generate.rb version 0.1.0
      """

  Scenario: Help
    When I run `./generate --help`
    Then the output should contain:
      """
      Usage: generate.rb [options]
              --version                    Show the version
              --help                       Display this help text
      """
