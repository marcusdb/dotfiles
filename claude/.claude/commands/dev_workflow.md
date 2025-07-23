---
description: Guide for using Task Master to manage task-driven development workflows
globs: **/*
alwaysApply: true
---


## Milestone discussion
- we are going to enter in planning mode.
- We are going to start working on a milestone, so for now we are going to enhance the description of the the milestone in the milestone file, so I need you to update this file as we talk about, do not update any other file or task for now until the milestone is fully discussed


## Standard Development Workflow Process
-   Make sure the the [activeContext.md](mdc:memory-bank/activeContext.md) document has the current goal/milestone you are working on
-   Begin coding sessions by fetching the tasks from this milesone from the github tooling
-   Determine the next task to work and confirm with the user
-   Analyze task complexity before breaking down tasks
-   Review complexity report using [complexity-report.md](mdc:memory-bank/complexity-report.md)
-   Select tasks based on dependencies (all marked 'closed'), priority level, and ID order
-   Clarify tasks by checking task details in the github issues tooling
-   View specific task details using the tooling to understand implementation requirements
-   Break down complex tasks
-   Implement code following task details, dependencies, and project standards
-   Verify tasks according to test strategies before marking as complete 
-   Mark completed tasks with status close
-   Update dependent tasks when implementation differs from original plan
-   Add new tasks discovered during implementation 
-   Add new subtasks as needed 
-   Append notes or details to subtasks 
-   Respect dependency chains and task priorities when selecting work
-   Report progress regularly by updating the tasks themselfs and by updating the [progress.md](mdc:memory-bank/progress.md) document

## Determining the Next Task

- Run check the task list for the current mileston to show the next possible tasks to work on
- Choose from high to low priority (accordingly to the priority labels), choose only tasks that are not blocked / do not depend by others tasks
- Tasks are prioritized by priority level, dependency count, and ID
- Recommended before starting any new development work
- Respects your project's dependency structure
- Ensures tasks are completed in the appropriate sequence


## Iterative Subtask Implementation

Once a task has been broken down into subtasks using `expand_task` or similar methods, follow this iterative process for implementation:

1.  **Understand the Goal (Preparation):**
    *   Use [milestones.md](mdc:memory-bank/milestones.md)

2.  **Initial Exploration & Planning (Iteration 1):**
    *   This is the first attempt at creating a concrete implementation plan.
    *   Explore the codebase to identify the precise files, functions, and even specific lines of code that will need modification.
    *   Determine the intended code changes (diffs) and their locations.
    *   Gather *all* relevant details from this exploration phase.

3.  **Log the Plan:**
    *   Run `update_subtask` / `task-master update-subtask --id=<subtaskId> --prompt='<detailed plan>'` (see @`taskmaster.mdc`).
    *   Provide the *complete and detailed* findings from the exploration phase in the prompt. Include file paths, line numbers, proposed diffs, reasoning, and any potential challenges identified. Do not omit details. The goal is to create a rich, timestamped log within the subtask's `details`.

4.  **Verify the Plan:**
    *   Run `get_task` / `task-master show <subtaskId>` again to confirm that the detailed implementation plan has been successfully appended to the subtask's details.

5.  **Begin Implementation:**
    *   Set the subtask status using `set_task_status` / `task-master set-status --id=<subtaskId> --status=in-progress` (see @`taskmaster.mdc`).
    *   Start coding based on the logged plan.

6.  **Refine and Log Progress (Iteration 2+):**
    *   As implementation progresses, you will encounter challenges, discover nuances, or confirm successful approaches.
    *   **Before appending new information**: Briefly review the *existing* details logged in the subtask (using `get_task` or recalling from context) to ensure the update adds fresh insights and avoids redundancy.
    *   **Regularly** use `update_subtask` / `task-master update-subtask --id=<subtaskId> --prompt='<update details>\n- What worked...\n- What didn't work...'` to append new findings.
    *   **Crucially, log:**
        *   What worked ("fundamental truths" discovered).
        *   What didn't work and why (to avoid repeating mistakes).
        *   Specific code snippets or configurations that were successful.
        *   Decisions made, especially if confirmed with user input.
        *   Any deviations from the initial plan and the reasoning.
    *   The objective is to continuously enrich the subtask's details, creating a log of the implementation journey that helps the AI (and human developers) learn, adapt, and avoid repeating errors.

7.  **Review & Update Rules (Post-Implementation):**
    *   Once the implementation for the subtask is functionally complete, review all code changes and the relevant chat history.
    *   Identify any new or modified code patterns, conventions, or best practices established during the implementation.
    *   Create new or update existing Cursor rules in the `.cursor/rules/` directory to capture these patterns, following the guidelines in @`cursor_rules.mdc` and @`self_improve.mdc`.

8.  **Mark Task Complete:**
    *   After verifying the implementation and updating any necessary rules, mark the subtask as completed: `set_task_status` / `task-master set-status --id=<subtaskId> --status=done`.

9.  **Commit Changes (If using Git):**
    *   Stage the relevant code changes and any updated/new rule files (`git add .`).
    *   Craft a comprehensive Git commit message summarizing the work done for the subtask, including both code implementation and any rule adjustments.
    *   Execute the commit command directly in the terminal (e.g., `git commit -m 'feat(module): Implement feature X for subtask <subtaskId>\n\n- Details about changes...\n- Updated rule Y for pattern Z'`).
    *   Consider if a Changeset is needed according to @`changeset.mdc`. If so, run `npm run changeset`, stage the generated file, and amend the commit or create a new one.

10. **Proceed to Next Subtask:**
    *   Identify the next subtask in the dependency chain (e.g., using `next_task` / `task-master next`) and repeat this iterative process starting from step 1.

## Code Analysis & Refactoring Techniques

- **Top-Level Function Search**:
    - Useful for understanding module structure or planning refactors.
    - Use grep/ripgrep to find exported functions/constants:
      `rg "export (async function|function|const) \w+"` or similar patterns.
    - Can help compare functions between files during migrations or identify potential naming conflicts.

---
*This workflow provides a general guideline. Adapt it based on your specific project needs and team practices.*