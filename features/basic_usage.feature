Feature: Basic Usage
  Scenario: Defaults
    Given a file named "action.yml" with:
      """
      name: Generate GitHub Action documentation
      description: >-
        Generates documentation from your GitHub Action's `action.yml`
      """
    When I run `actiondoc`
    Then the output should contain:
      """
      Generate GitHub Action documentation
      ====

      Generates documentation from your GitHub Action's `action.yml`
      """

  Scenario: Renders inputs as a table
    Given a file named "action.yml" with:
      """
      name: actiondoc
      description: >-
        Generates documentation from your GitHub Action's `action.yml`

      inputs:
        path-to-action-yml:
          description: >-
            The path to the `action.yml` file to generate documentation for.
          required: false
      """
    When I run `actiondoc`
    Then the output should contain exactly:
      """
      actiondoc
      ====

      Generates documentation from your GitHub Action's `action.yml`

      ## Inputs

      | Name               | Description                                                      | Required | Default |
      |--------------------|------------------------------------------------------------------|----------|---------|
      | path-to-action-yml | The path to the `action.yml` file to generate documentation for. | No       |         |
      """

  Scenario: Version
    When I run `actiondoc --version`
    Then the output should contain exactly:
      """
      actiondoc v0.1.0
      """

  Scenario: Help
    When I run `actiondoc --help`
    Then the output should contain:
      """
      Usage: actiondoc [options]
              --version                    Show the version
              --help                       Display this help text
      """
