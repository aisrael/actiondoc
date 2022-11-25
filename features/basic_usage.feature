Feature: Basic Usage
  Background:
    Given an executable named "generate" with:
      """
      #!/bin/bash
      ruby ../../generate.rb $@
      """

  Scenario: Defaults
    Given a file named "action.yml" with:
      """
      name: Generate GitHub Action documentation
      description: >-
        Generates documentation from your GitHub Action's `action.yml`
      """
    When I run `./generate`
    Then the output should contain:
      """
      Generate GitHub Action documentation
      ====

      Generates documentation from your GitHub Action's `action.yml`
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
