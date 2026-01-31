---
description: "Execute a non-code task (config, infra, docs, scripts) with guaranteed working results and code review loop. For source code changes, use /tdd-task instead."
argument-hint: [task-description or path to .tasks/TASK-XXX.json]
---

# Task Execution

Execute the task below with an implement-review loop until the code is
approved.

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

1. **Implement** — Use the @task-executer agent (not task-executor-tdd).
   Pass it the task description above. It must verify the codebase is
   clean before starting, implement incrementally, verify everything
   works, and commit after each increment.

2. **Review** — Use the @clean-code-ts-reviewer agent to review the
   implementation. It must verify compilation, all tests pass, type
   safety, clean code principles, and security.

3. **Evaluate** — If the review is APPROVED, exit the loop. If the
   review found issues, feed the review findings back to step 1 and
   repeat. Do NOT skip issues or mark the task complete with an
   unapproved review. This is mandatory.

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

Issues Found and Fixed:
- <any issues, including unrelated ones>

Files Changed:
<output of git diff --stat>
---
```

### 3. Commit

Stage all changed files (including the updated task JSON and
progress.txt) and create a git commit with the message:

```
feat(TASK-XXX): <short task title> and a description of the work.
```

If there is no task ID, use a conventional commit message describing
the work.

### 4. Report

Output a summary to the user:
- Work done in concise bullet points
- Issues found and fixed (including unrelated ones)
- Files and line changes
