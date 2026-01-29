---
description: execute the task requested
argument-hint: [task] 
---

# Task executer
Follow the 'Workflow' below to execute the 'TASK' as especified.


## Variables

TASK: $ARGUMENTS

## Workflow

Given a TASK follow the "implementation_loop" until completion
<implementation_loop>

1. Use @task-executer (not the task-executor-tdd agent) pass it the TASK as the prompt
2. then use the @clean-code-ts-reviewer agent to review the code
3. If the code review was not approved or has issues to fix go back to step 1 of the loop, otherwise finish the loop. YOU MUST START THE LOOP AGAIN AND ADDRESS THE ISSUES IF THE REVIEW IS NOT APPROVED THIS IS MANDATORY
</implementation_loop>
After the TASK is complete, respond in the 'Report' Format

## Report

- Summarize the work you've just done in a concise bullet point list.
- Report the files an total lines change with 'git diff --stat'