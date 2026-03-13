---
name: code-simplicity
description: >
  Principles for writing simple, maintainable code that manages complexity through deep modules,
  clean interfaces, and pragmatic design tradeoffs. Use this skill when writing, reviewing, or
  refactoring code of any kind — especially when designing new modules, services, APIs, or
  abstractions. Also trigger when the user asks about code structure, architecture decisions,
  how to organize code, reduce complexity, or improve readability. If the user mentions
  "clean code", "simplicity", "refactor", "code review", "design", "architecture", or
  "complexity", consult this skill. This skill applies to all languages but uses Go and Python
  in its examples.
---

# Code Simplicity

This skill encodes a philosophy: **complexity is the central problem of software engineering**.
Every design decision should be evaluated by whether it reduces, hides, or accidentally
introduces complexity. The goal is not "clean code" as aesthetic ritual — it's working software
that remains understandable and changeable over time.

These principles are tools, not laws. Every one of them has a point where it stops helping and
starts hurting. The guidance below tries to mark those boundaries honestly.

## Core Philosophy

### Eliminate complexity. If you can't eliminate it, hide it.

Complexity has two forms:

1. **Essential complexity** — inherent to the problem (retry logic, protocol negotiation, concurrent state). You can't remove it.
2. **Accidental complexity** — introduced by your design choices (unnecessary abstractions, poor naming, leaky interfaces). You can remove it.

Your first move is always to ask: *can I eliminate this complexity entirely?* Sometimes a simpler
algorithm, a smaller feature scope, or a different data representation makes the problem trivially
easy. Only when you're sure the complexity is essential should you move to the second strategy:
hide it behind a good interface so the rest of the codebase doesn't need to know.

### Deep modules over shallow modules

This is the single most important structural idea in this skill, drawn from John Ousterhout's
*A Philosophy of Software Design*.

A **deep module** provides a powerful capability behind a simple interface. The ratio of
functionality to interface complexity is high. Think of the Unix file system: five basic calls
(`open`, `read`, `write`, `seek`, `close`) hide enormous complexity — buffering, caching,
disk scheduling, journaling, permissions.

A **shallow module** exposes an interface nearly as complex as its implementation. It forces
callers to understand the internals anyway, which means the abstraction isn't actually carrying
its weight.

**What this means in practice:**

- Prefer fewer, more capable functions over many tiny ones that just delegate.
- An interface should let callers forget about what's behind it. If callers need to know
  implementation details to use it correctly, the abstraction is leaking.
- Don't split code into small pieces just to satisfy a line-count rule. A 60-line function
  that does one coherent thing is better than six 10-line functions that only make sense
  together and have to be read as a group.

**When shallow is fine:** Data transfer objects, configuration structs, simple value types —
these are inherently shallow and that's appropriate. The warning is against *creating*
shallow abstractions where a deep one would serve better.

### Information hiding is the mechanism

Deep modules work because of **information hiding**: each module embeds design decisions
(data structures, algorithms, error handling strategies) that its interface doesn't expose.
When a decision is hidden, it can change without affecting callers.

The opposite — **information leakage** — is when implementation details escape into the
interface or when two modules both depend on the same piece of knowledge without either
owning it. Information leakage is the most common source of accidental coupling.

Ask yourself: *if I changed this internal decision, how many other files would I have to
touch?* If the answer is more than one, you have a leak.

---

## Design Principles

Read `references/principles.md` for detailed principles with before/after code examples.
It covers:

1. **Single Responsibility** — each unit has one reason to change
2. **Dependency Inversion** — depend on interfaces, not implementations
3. **DRY with judgment** — extract shared logic, but don't force unrelated things together
4. **Least Surprise** — code should do what a reader expects from its name and signature
5. **Open/Closed** — extend behavior without modifying existing code
6. **Error handling as design** — errors are part of the interface, not an afterthought

Each principle includes guidance on when it helps and when it hurts.

---

## Pragmatic Tradeoffs

These are the pressure-release valves that keep principles from becoming dogma.

### Don't abstract prematurely

If you've seen a pattern once, just write the code. If you've seen it twice, note the
duplication but consider leaving it. Three times — now you have enough examples to know
what the *actual* common shape is, and you can extract a good abstraction.

Premature abstraction is worse than duplication because a wrong abstraction is expensive
to undo. Two copies of similar code are easy to read and easy to merge later. One bad
abstraction that everything depends on is a tar pit.

### Tolerate tactical complexity when strategic simplicity demands it

Sometimes a function is locally ugly because it's absorbing complexity that would otherwise
leak into ten call sites. That's a good trade. The function's internals are complex, but
the *system* is simpler because that complexity is contained.

Judge complexity at the system level, not the function level.

### Consistency beats local perfection

If the codebase uses pattern A and pattern B would be marginally better in one spot, use
pattern A. The cognitive cost of a reader encountering an unexpected pattern is real and
compounds across a codebase. Save pattern B for a codebase-wide migration.

### Inline is fine when the alternative is a trail of breadcrumbs

If extracting a helper means the reader has to jump to three files to understand a
straightforward flow, leave it inline. Extraction should make code *easier* to follow,
not just shorter.

### Optimize for the reader, not the writer

Code is read ~10x more than it's written. When in doubt, choose the version that a
teammate seeing this code for the first time would understand faster — even if it took
you slightly longer to write.

### Know when to stop

Not every module needs an interface. Not every function needs to be generic. Not every
pattern needs a name. If the code is clear, correct, and unlikely to change, leave it
alone. Over-engineering simple code is itself a form of complexity.

---

## Applying These Principles

When writing or reviewing code, run through this checklist mentally:

1. **Does this need to exist?** Can I solve the problem with less code, fewer abstractions,
   or an existing mechanism?
2. **Is this a deep module?** Does the interface hide meaningful complexity, or is it just
   shuffling code around?
3. **Where does the complexity live?** Is it contained in one place, or smeared across
   the codebase?
4. **What would a new reader think?** Would they understand the intent from names,
   structure, and types alone?
5. **What changes are likely?** Design for flexibility along the axes that are *actually*
   likely to change. Don't generalize against hypothetical future requirements.
6. **Am I making a tradeoff or following a rule?** If you can't articulate *why* a
   principle applies here, you might be applying it out of habit.

---

## Anti-patterns to Watch For

- **Shallow wrappers**: A function that just calls another function with the same arguments.
  Unless it's providing a genuinely simpler interface, it's just indirection.
- **Speculative generality**: Interfaces with one implementation, type parameters that are
  never varied, factory patterns for objects that are always constructed the same way.
- **Pass-through methods**: Methods on a class that just forward to a field. Often a sign
  the decomposition is wrong.
- **Configuration explosion**: When "flexibility" means the caller has to set 15 options
  to get basic behavior. Deep modules have good defaults.
- **Shotgun surgery**: A single logical change requires edits in many files. Usually means
  a design decision leaked instead of being hidden.
- **Primitive obsession**: Passing around raw strings and ints when a small type would
  make interfaces self-documenting and prevent misuse.

