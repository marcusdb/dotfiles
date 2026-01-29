---
description: Execute a task using strict TDD (Red-Green-Refactor) with code review loop
argument-hint: [task-description]
---

# TDD Task Execution

Execute the task below using test-driven development with an
implement-review loop until the code is approved.

## Task

$ARGUMENTS

## Context

- Current branch: !`git branch --show-current`
- Working tree status: !`git status --short`
- Recent commits: !`git log --oneline -5`

## Workflow

Follow this loop until the review passes:

<implementation_loop>

1. **Implement with TDD** — Use the @task-executor-tdd agent. Pass it
   the task description above. It must follow Kent Beck's Canon TDD:
   write a failing test first, make it pass with minimal code, then
   refactor. Every increment must be committed with a clean test suite.

2. **Review** — Use the @clean-code-ts-reviewer agent to review the
   implementation. It must verify compilation, all tests pass, type
   safety, clean code principles, and security.

3. **Evaluate** — If the review is APPROVED, exit the loop. If the
   review found issues, feed the review findings back to step 1 and
   repeat. Do NOT skip issues or mark the task complete with an
   unapproved review. This is mandatory.

</implementation_loop>

## Report

After the loop completes with an approved review:

- Summarize the work done in concise bullet points
- List the TDD cycles completed (tests written, increments committed)
- Report files and line changes: !`git diff --stat`
