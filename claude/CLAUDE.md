- ALWAYS perform a code review before commiting any change
- We should ALMOST NEVER write Go code that panics
- NEVER include claude as an author in commit messages
- Anytime we have any task that we need to do we should add them to TODO.md. As we work through changes we should add our progress to PROGRESS.md. Whenever we are done with a TODO we should check it off in TODO.md
- As we work through our items, create an ADR documenting architectural decisions and why. Include other options that were discarded and why.
- ADRs should go in an ADR directory in the root of the package we're working on
- All ADRs should be numbered and when we change an ADR, create a new one with what we're changing, why and deprecate the old one
- Before committing code, ensure we perform a code review. We want to focus on
  simplicity and security.

### Unit Test Quality Rules

- **No tautological tests**: Do not write tests that only assert mock return
  values are passed through unchanges or that struct or class fields store what
  you give them. Every test muse exercise real logic (branching, mapping,
  validation, error handling)
- Whenever we make changes and before we commit them, we want to make sure we
  have or have created tests for those changes. We want to make sure that we
  have 3 happy tests and 1 sad test and that we've run those tests.
- **Parameterize over copy paste**: When 2+ tests share the same structure with
  different inputs use sub tests and ensure they're created as table tests.
  Prefer boolean flags over functions in test definitions.
- **Test at the right layer**: Validation and Parsing tests shouldn't happen in
  handler tests.
- **Don't test the framework**
