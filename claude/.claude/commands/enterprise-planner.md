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
- Existing tasks: !`ls .tasks/ 2>/dev/null || echo "No .tasks/ directory"`

## Preparation

Before starting the planning loop, ensure a clean slate:
- If `.tasks/` exists and contains files, remove its contents
- Create `.tasks/` if it does not exist

Do this exactly once, before Phase 1. Never clean up during the loop.

## Planning Loop

Repeat Phases 1–3 until every task has complexity 7 or below.

### Phase 1: Task Planning

Use the @enterprise-architect-task-planner agent. Pass it the
specification above. It will:

- Analyze the requirements and identify all implementation work
- Create atomic, sequenced tasks with dependencies and testing strategies
- Write `.tasks/tasks.json` (index with IDs, titles, dependencies,
  priorities, status) and one `.tasks/{taskId}.md` per task

### Phase 2: Complexity Analysis

Use the @enterprise-complexity-analyst agent. It will:

- Read `.tasks/tasks.json` and score every unscored task (1–10 scale)
- Update `.tasks/tasks.json` in place with complexity ratings
- Flag any task scoring 7+ with decomposition recommendations

### Phase 3: Decomposition (if any task scores above 7)

For each task with complexity above 7:

1. Use @enterprise-architect-task-planner again to decompose it into
   smaller subtasks — each targeting complexity 5 or below
2. Mark the parent task as `[DECOMPOSED]` in `.tasks/tasks.json` — set
   its status so it is not worked on directly
3. Add subtasks with `parentTaskId` linking to the decomposed parent
4. Update `.tasks/tasks.json` with all new subtasks

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
- `.tasks/tasks.json` is consistent with individual task files

## Report

After the loop completes:

- Total tasks and breakdown by priority (High / Medium / Low)
- Complexity distribution (1–3, 4–6, 7)
- Number of decomposition cycles performed
- Tasks decomposed and subtasks created
- Critical path (longest dependency chain)
- Parallelization opportunities
- Escalations or open risks (if any)
