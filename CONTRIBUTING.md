# Contributing to dart_json_schema_form

Thanks for your interest in contributing 🎉

## Development Setup
1. Fork and clone this repository.
2. Install dependencies:
   ```bash
   flutter pub get
   cd example && flutter pub get
   ```

3. Run tests:

   ```bash
   flutter test
   cd example && flutter test
   ```

## Code Style

* Use **English** for comments and variable names.
* Follow Flutter/Dart best practices:

  ```bash
  dart analyze
  flutter format .
  ```
* Avoid warnings on `dart analyze`.
* Add unit/widget tests for any new feature or bugfix.

## Examples and Documentation

* Add a new example in the **example app** when introducing a new feature.
* Always run the tests in the **example app** if you make changes.
* Update `README.md` with examples if necessary.

## Commits & Pull Requests

* Use clear commit messages.
  (Following [Conventional Commits](https://www.conventionalcommits.org/) is recommended but not required.)
* Create a new branch per feature/bugfix.
* Use **Squash and Merge** when merging PRs into the `main` branch.

## Issues

* Use GitHub Issues to report bugs or request features.
* Please provide reproducible steps when reporting bugs.

Thank you for helping improve `dart_json_schema_form` 🙏
