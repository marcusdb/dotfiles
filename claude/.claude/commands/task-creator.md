---
description: Break down a spec into tasks, score complexity, and decompose until no task exceeds complexity 7
argument-hint: [spec-or-requirements]
model: opus
---

# Enterprise Planning

Break down the specification below into implementation tasks, analyze
their complexity, and iteratively decompose any task scoring above 7
until every task is actionable and manageable.

## Specification

$ARGUMENTS

## Context

- Current branch: !`git branch --show-current`
- Working tree status: !`git status --short`
- Existing tasks: !`ls .tasks/TASK-*.json 2>/dev/null || echo "No task files found"`

## Preparation

Before starting the planning loop, ensure a clean slate:
- If `.tasks/` exists and contains files, remove its contents
- Create `.tasks/` if it does not exist

Do this exactly once, before Phase 1. Never clean up during the loop.

## Planning Loop

Repeat Phases 1–3 until every task has complexity 7 or below.

### Phase 1: Task Planning

Use the @task-planner agent. Pass it the specification above. It will:

- Analyze the requirements and identify all implementation work
- Create atomic, sequenced tasks with dependencies and testing strategies
- Write individual `.tasks/TASK-XXX.json` files (one per task)
- No summary index file — individual task files are the source of truth

### Phase 2: Complexity Analysis

Use the @task-complexity agent. It will:

- Glob for `.tasks/TASK-*.json` and score every unscored task (1–10 scale)
- Update each `.tasks/TASK-XXX.json` in place with a `"complexity"` field
- Flag any task scoring 7+ with decomposition recommendations

### Phase 3: Decomposition (if any task scores above 7)

For each task with complexity above 7:

1. Use @task-planner again to decompose it into smaller subtasks — each
   targeting complexity 5 or below
2. Mark the parent task as `"status": "decomposed"` in its
   `.tasks/TASK-XXX.json` file so it is not worked on directly
3. Add subtask files with `parentTaskId` linking to the decomposed parent

Then return to Phase 2 to score the new subtasks. Continue until no
task exceeds complexity 7.

If a task cannot be decomposed further but remains above 7, flag it as
an escalation — explain why it is irreducible and what risks it carries.

## Quality Gate

Before reporting completion, verify:

- All tasks have complexity 7 or below (or are flagged as irreducible)
- No orphaned tasks — every subtask has a valid parent reference
- No circular dependencies
- Dependencies are sequenced logically (foundational work first)
- Individual `.tasks/TASK-XXX.json` files are consistent and well-formed

## Report

After the loop completes:

- Total tasks and breakdown by priority (High / Medium / Low)
- Complexity distribution (1–3, 4–6, 7)
- Number of decomposition cycles performed
- Tasks decomposed and subtasks created
- Critical path (longest dependency chain)
- Parallelization opportunities
- Escalations or open risks (if any)
