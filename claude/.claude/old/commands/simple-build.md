---
description: Build the codebase based on the plan
argument-hint: [path-to-plan]
allowed-tools: Read, Write, Bash
---

# Build

Follow the 'Workflow' to implement the 'PATH-TO-PLAN' then 'Report' the complete work

## Variables

PATH-TO-PLAN: $ARGUMENTS

## Workflow

- If no 'PATH-TO-PLAN' is provided, STOP immediately and ask the user to provide it.
- Read the plan at: 'PATH-TO-PLAN'. Think hard about the plan and implement it into the codebase.

## Report

- Summarize the work you've just done in a concise bullet point list.
- Report the files an total lines change with 'git diff --stat'