- ALWAYS perform a code review before commiting any change
- We should ALMOST NEVER write Go code that panics
- NEVER include claude as an author in commit messages
- Anytime we have any task that we need to do we should add them to TODO.md. As we work through changes we should add our progress to PROGRESS.md. Whenever we are done with a TODO we should check it off in TODO.md
- As we work through our items, create an ADR documenting architectural decisions and why. Include other options that were discarded and why.
- ADRs should go in an ADR directory in the root of the package we're working on
- All ADRs should be numbered and when we change an ADR, create a new one with what we're changing, why and deprecate the old one
- Whenever we make changes and before we commit them, we want to make sure we
  have or have created tests for those changes. We want to make sure that we
  have 3 happy tests and 1 sad test and that we've run those tests. 
- Before committing code, ensure we perform a code review. We want to focus on
  simplicity and security.
