---
description: Create a concise engineering implementation plan and save it to specs/
allowed-tools: Read, Write, Edit, Glob, Grep, MultiEdit
argument-hint: [requirements-or-feature-description]
model: opus
---

# Quick Plan

Analyze the requirements below, explore the codebase for relevant
context, and produce a focused implementation plan saved to `specs/`.

## Requirements

$ARGUMENTS

## Context

- Current branch: !`git branch --show-current`
- Project structure: !`ls -d */ 2>/dev/null | head -20`
- Existing specs: !`ls specs/*.md 2>/dev/null || echo "No specs yet"`

## Workflow

### 1. Understand the Problem

- Read the requirements carefully — identify the core problem and
  desired outcome
- Explore the codebase to understand existing patterns, architecture,
  and conventions
- Identify relevant files, modules, and interfaces that will be affected
- Use Context7 if third-party libraries are involved

### 2. Design the Solution

Think through the approach before writing anything:

- What is the simplest design that satisfies the requirements?
- What existing patterns in the codebase should be followed?
- What are the key technical decisions and trade-offs?
- What could go wrong — edge cases, failure modes, security concerns?

### 3. Write the Plan

Create a markdown file at `specs/<descriptive-kebab-case-name>.md` with
these sections:

```markdown
# [Plan Title]

## Problem Statement
[What problem this solves and why it matters]

## Approach
[High-level technical approach and key architecture decisions]

## Implementation Steps
[Ordered list of concrete steps — specific enough that another
developer could follow them without asking questions]

## Files Affected
[List of files to create or modify, with brief description of changes]

## Testing Strategy
[What to test, test types, key scenarios, edge cases]

## Risks and Open Questions
[Anything uncertain, any trade-offs made, any decisions deferred]
```

Include code examples or pseudo-code where they clarify complex logic.
Keep it concise — a plan, not a novel.

## Report

After saving the plan:

- File path where the plan was saved
- One-line summary of what the plan covers
- Key components or steps (3–5 bullet points)
