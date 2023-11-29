Feature: Basic Usage
  Scenario: Defaults
    Given a file named "action.yml" with:
      """
      name: Generate GitHub Action documentation
      description: >-
        Generates documentation from your GitHub Action's `action.yml`
      """
    When I run `actiondoc`
    Then the output should contain exactly:
      """
      Generate GitHub Action documentation
      ====

      Generates documentation from your GitHub Action's `action.yml`

      ## Inputs

      This action has no inputs.
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

  Scenario: Supports path-to-action-yml
    Given a file named "path/to/action.yml" with:
      """
      name: Generate GitHub Action documentation
      description: >-
        Generates documentation from your GitHub Action's `action.yml`
      """
    When I run `actiondoc path/to/action.yml`
    Then the output should contain:
      """
      Generate GitHub Action documentation
      ====

      Generates documentation from your GitHub Action's `action.yml`
      """

  Scenario: Version
    When I run `actiondoc --version`
    Then the output should contain exactly:
      """
      actiondoc v0.3.0
      """

  Scenario: Help
    When I run `actiondoc --help`
    Then the output should contain:
      """
      Usage:

          actiondoc [options] [ACTION_YAML_FILE]

      Where:
          [ACTION_YAML_FILE]               is the path to the action.yaml file. Defaults to "action.yaml"
                                           in the current directory.

      Options:
          -t, --template=TEMPLATE_FILENAME The template to use
              --version                    Show the version
              --help                       Display this help text
      """
