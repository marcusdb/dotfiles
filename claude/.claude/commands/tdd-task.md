---
description: "USE THIS FOR ALL CODE CHANGES. Execute a task using strict TDD (Red-Green-Refactor) with code review loop. Preferred for any task that writes, modifies, or deletes source code."
argument-hint: [task-description or path to .tasks/TASK-XXX.json]
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
- Existing task files: !`ls .tasks/TASK-*.json 2>/dev/null || echo "No task files found"`

## Task File Detection

If `$ARGUMENTS` is a path to a `.tasks/TASK-*.json` file, or contains a
task ID like `TASK-001`:

1. Read the task JSON file to get the full task details
2. Note the `taskId` — you will need it for the completion steps
3. Set the task status to `in_progress` by editing the JSON file's
   `"status"` field from `"pending"` to `"in_progress"` before starting work

If the argument is a plain text description (not a task file), proceed
normally without task file operations.

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

**CRITICAL: You MUST fix ALL issues found — including pre-existing
issues not caused by your changes. Never work on a broken codebase.
If compilation, tests, linting, or type-checking fail for ANY reason,
fix those failures before proceeding. No exceptions.**

</implementation_loop>

## Completion

After the loop completes with an approved review, perform ALL of the
following steps in order:

### 1. Mark Task Complete (if working with a task file)

Edit the task JSON file and set `"status": "complete"`.

### 2. Append to Progress Log

APPEND a progress entry to `.tasks/progress.txt`. Do NOT overwrite or
edit existing content — always append to the end of the file. Create
the file if it does not exist.

Use this format exactly:

```
---
[TASK-XXX] <task title>
Date: <YYYY-MM-DD>
Status: COMPLETE

Summary:
- <bullet points of work done>

TDD Cycles:
- <tests written and increments committed>

Files Changed:
<output of git diff --stat>
---
```

### 3. Commit

Stage all changed files (including the updated task JSON and
progress.txt) and create a git commit with the message:

```
feat(TASK-XXX): <short task title> and a descripton of the work.
```

If there is no task ID, use a conventional commit message describing
the work.

### 4. Report

Output a summary to the user:
- Work done in concise bullet points
- TDD cycles completed
- Files and line changes
