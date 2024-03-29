actiondoc
====

[![Tests](https://github.com/aisrael/actiondoc/actions/workflows/tests.yml/badge.svg)](https://github.com/aisrael/actiondoc/actions/workflows/tests.yml)

Generates documentation from your GitHub Action's `action.yml`

## Inputs

| Name               | Description                                                                                              | Required | Default |
|--------------------|----------------------------------------------------------------------------------------------------------|----------|---------|
| template-filename  | The path to the ERB template to use to generate the documentation.                                       | No       |         |
| output-filename    | The filename to save the output to. If not specified, simply prints to standard output.                  | No       |         |
| path-to-action-yml | The path to the `action.yml` file to generate documentation for. If not specified, assumes `action.yml`. | No       |         |
| working-directory  | The directory to perform the action in, if not $GITHUB_WORKSPACE                                         | No       |         |

actiondoc is both a Ruby Gem _and_ a GitHub Action that uses that gem to generate a suitable `README.md` from
an optional ERB template, intended to help keep your own action's documentation up-to-date with the actual inputs.

See [Basic Usage](features/basic_usage.feature) for some basic usage of the gem.

### Example

Given an `action.yml` that contains:

```yaml
name: actiondoc
  description: >-
    Generates documentation from your GitHub Action's `action.yml`

  inputs:
    path-to-action-yml:
      description: >-
        The path to the `action.yml` file
        required: false
```

Then when running `actiondoc` it should output

```markdown
actiondoc
====

Generates documentation from your GitHub Action's `action.yml`

## Inputs

| Name               | Description                       | Required | Default |
|--------------------|-----------------------------------|----------|---------|
| path-to-action-yml | The path to the `action.yml` file | No       |         |
```

## Use it in a workflow to update your action's README

### Commit & push directly to update the README.md

The following sample workflow uses this repository as a GitHub Action directly, and commits the updated
README.md directly.


```yaml
name: Generate README
on:
  push:
    paths:
      - action.yml
      - README.md.erb

jobs:
  generate-readme:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - run: if [ -f README.md ]; then rm README.md; fi
      - name: Generate README
        uses: aisrael/actiondoc@v2
        with:
          template-filename: README.md.erb
          output-filename: README.md
      - run: |
          cat README.md
      - name: Commit & Push changes
        uses: actions-js/push@master
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
```


### Create a PR to update the README.md

The following sample workflow uses this repository as a GitHub Action directly, and creates a PR (using
[peter-evans/create-pull-request](https://github.com/peter-evans/create-pull-request)) to
update `README.md` on any changes to either `action.yml` or `README.md.erb`.


```yaml
name: Generate README
on:
  push:
    paths:
      - action.yml
      - README.md.erb

jobs:
  generate-readme:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - run: if [ -f README.md ]; then rm README.md; fi
      - name: Generate README
        uses: aisrael/actiondoc@v2
        with:
          template-filename: README.md.erb
          output-filename: README.md
      - run: |
          cat README.md
      - name: Create Pull Request
        uses: peter-evans/create-pull-request@v4
        with:
          add-paths: README.md
          base: main
          branch: update-readme
          delete-branch: true
          title: Update README.md
```
