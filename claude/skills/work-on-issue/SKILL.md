---
name: work-on-issue
description: >
  Full GitHub issue workflow: fetch issue, explore codebase, plan implementation,
  create branch, implement with tests, run language-appropriate linters, update
  TODO/PROGRESS, commit. Follows all project conventions (ADRs, test requirements,
  commit format, no panics).
  Trigger with: /work-on-issue #N or /work-on-issue <github-url>
---

You are executing the `work-on-issue` skill. The user has provided an issue reference.
Extract the issue number from whatever form they provided (e.g. `#123`,
`https://github.com/clly/skud/issues/123`, or plain `123`).

Work through the phases below in order. Do not skip phases. Before writing any
code, you must complete Phases 1–3 and receive explicit user approval.

---

## Phase 1 — Issue Intake

1. Fetch the issue using `mcp__github__get_issue` (repo: `clly/skud`). Capture:
   title, body, labels, milestone, assignees.
2. Fetch comments with `mcp__github__get_issue_comments` for additional context.
3. Check for an existing branch: `git branch -r | grep "issue/<number>"`.
4. Check `TODO.md` and `PROGRESS.md` for any existing tracking entries.
5. Output a short summary:
   - What the issue asks for
   - Inferred acceptance criteria (bullet list)
   - Whether a branch or tracking entry already exists

---

## Phase 2 — Codebase Orientation

Use the Explore agent to map the issue to code. Identify:
- Which packages/files are relevant
- Which module(s) are affected (Go root, bookmarks, cfgmgt, gopik, mrt, web, extension)
- Related existing tests and the patterns they use
- What code generation is needed: sqlc, buf, Vite build, Flyway migration

List findings concisely before moving on.

---

## Phase 3 — Plan & Review

Produce a written implementation plan:
- Approach summary (1–3 sentences)
- Files to modify (with reason)
- New files to create (with reason)
- Test plan: name 3 specific happy-path scenarios + 1 specific sad-path scenario
  (concrete inputs/outputs, not generic descriptions)
- Language(s) touched and which lint/test commands will be run

**Enter plan mode now.** Wait for the user to explicitly approve before touching
any files or running any commands.

---

## Phase 4 — ADR Prompt

Ask the user: "Does this issue involve an architectural decision that warrants
an ADR?"

If yes:
- Find the next available ADR number in `bookmarks/ADR/` (or the relevant
  module's ADR directory).
- Draft `<N>-<slug>.md` using the existing ADR format:
  - **Status**, **Context**, **Decision**, **Alternatives Considered**,
    **Consequences**
- Write the file before proceeding.

If no: continue to Phase 5.

---

## Phase 5 — Branch & Implement

1. Create branch: `git checkout -b issue/<number>-<slug>` where `<slug>` is a
   short kebab-case summary of the issue title (max 5 words).
2. Add an entry to `TODO.md` for this issue (will be checked off in Phase 8).
3. Implement all changes following these hard rules:
   - **No panics** — return errors instead.
   - **Context everywhere** — pass `ctx` to all blocking calls; check `ctx.Err()`
     at the top of every loop over external or unbounded data.
   - **Sentinel errors** — define package-level errors and wrap with `%w`.
   - **Information hiding** — unexported types for internal state; exported only
     what callers need.
   - **No tautological logic** — every branch of real code must be reachable.

---

## Phase 6 — Tests & Linting

Write tests before running lint. Requirements:
- **3 happy-path + 1 sad-path** test (per changed Go package minimum).
- **Table-driven** when 2+ cases share the same structure.
- **No tautological tests** — assert real logic (branching, mapping, validation,
  error handling), not that a mock returns what you told it to return.
- **Test at the right layer** — validation/parsing tests belong in unit tests,
  not handler tests.

Run the appropriate commands for every language touched:

| Language | Lint | Test |
|----------|------|------|
| Go | `cd <module> && golangci-lint run ./...` | `cd <module> && go test -race ./...` |
| TypeScript (web) | `cd web && bun run type-check` | `cd web && bun run test -- --run --coverage` |
| TypeScript (extension) | `cd extension && tsc --noEmit` | `cd extension && vitest run` |
| SQL | `sqlfluff lint db/schema.sql db/triggers.sql db/flyway/*.sql --dialect sqlite` | n/a |

Or run everything: `mise run check`

Fix all lint errors and test failures before continuing.

---

## Phase 7 — Code Review

Invoke the `/code-simplicity` skill and the `/go-review` skill (if Go was
changed) against all modified files.

Checklist to verify manually:
- [ ] No panics introduced
- [ ] Context passed and checked in loops
- [ ] Errors wrapped with `%w`, not concatenated
- [ ] Input validated at system boundaries only
- [ ] No SQL/command/template injection vectors
- [ ] Tests exercise real logic — no tautological assertions
- [ ] No unnecessary abstractions or helpers for one-off use

Address any issues found before committing.

---

## Phase 8 — Commit & Tracking

1. Update `PROGRESS.md` — describe what was done and link to the issue.
2. Check off the entry in `TODO.md`.
3. Stage only the files changed for this issue (prefer named files over
   `git add .`).
4. Commit with format:

   ```
   type(module): short description (#<issue-number>)
   ```

   Where `type` is one of: `feat`, `fix`, `refactor`, `test`, `docs`, `chore`.
   `module` is the affected module or package (e.g. `bookmarks`, `mrt`, `daemon`).

   **Do NOT include a `Co-Authored-By: Claude` line.**

5. Stop here. Inform the user the branch is ready and they can open a PR when
   ready.

---

## Convention Reference

| Convention | Rule |
|-----------|------|
| Tests | 3 happy + 1 sad; table tests for 2+ similar cases; no tautological tests |
| Commit format | `type(module): description (#N)` — no claude authorship |
| Go safety | No panics; context everywhere; sentinel errors with `%w` |
| Tracking | Update TODO.md (check off at end) + PROGRESS.md |
| Module targeting | `cd <module> && go test -race ./...` — never from repo root for sub-modules |
| Pre-commit linting | Per-language commands above; all must pass |
| ADR | Always prompt; store in `<module>/ADR/<N>-<slug>.md` |
| Branch naming | `issue/<number>-<slug>` |
