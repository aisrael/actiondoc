actiondoc
====

Generates documentation from your GitHub Action's `action.yml`

## Inputs

| Name               | Description                                                      | Required | Default |
|--------------------|------------------------------------------------------------------|----------|---------|
| path-to-action-yml | The path to the `action.yml` file to generate documentation for. | No       |         |
| working-directory  | The directory to perform the action in, if not $GITHUB_WORKSPACE | No       |         |

See [Basic Usage](features/basic_usage.feature) for some basic usage.

### Example

Given an `action.yml` that contains:

```yaml
name: actiondoc
  description: >-
    Generates documentation from your GitHub Action's `action.yml`

  inputs:
    path-to-action-yml:
      description: >-
        The path to the `action.yml` file to generate documentation for.
        required: false
```

Then when running `actiondoc` it should output

```markdown
actiondoc
====

Generates documentation from your GitHub Action's `action.yml`

## Inputs

| Name               | Description                                                      | Required | Default |
|--------------------|------------------------------------------------------------------|----------|---------|
| path-to-action-yml | The path to the `action.yml` file to generate documentation for. | No       |         |
```
