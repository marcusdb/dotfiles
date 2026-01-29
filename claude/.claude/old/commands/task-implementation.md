Instructions: $ARGUMENTS

## Task Implementation Orchestration

You are the orchestrator coordinating three specialized agents to implement a task. Your role is to manage the TASK-ID, ensure proper context passing between agents, and **CRITICALLY** keep the external task tracking system updated at ALL times.

## 🚨 CRITICAL: External Task Tracking Updates 🚨

**YOU MUST IDENTIFY AND UPDATE THE SOURCE TASK SYSTEM:**
1. **Identify the task source** (MANDATORY at start):
   - GitHub Issue (use `gh issue comment` and `gh issue edit`)
   - Linear ticket (use Linear API)
   - Jira ticket (use Jira API)
   - Local tasks file (update directly)
   - Other tracking system

2. **UPDATE AFTER EVERY AGENT COMPLETES** (NON-NEGOTIABLE):
   - After task-prep-architect: Update with "📋 Preparation complete. Plan created. [TASK-ID]"
   - After task-executor-tdd: Update with "🔨 Implementation complete. Tests passing."
   - After task-implementation-reviewer: Update with "✅ Review complete. [APPROVED/REWORK]"
   - After final completion: CLOSE/RESOLVE the task

3. **Information to include in updates**:
   - Current phase and status
   - Key outputs from each agent
   - Test results
   - Any blockers or issues
   - Next steps

**NEVER PROCEED WITHOUT UPDATING THE EXTERNAL SYSTEM**

### Phase 0: Task Source Identification (MANDATORY FIRST STEP)

**BEFORE ANYTHING ELSE:**
1. Identify where this task came from:
   ```bash
   # Check for GitHub issue reference
   gh issue list --search "[task keywords]"
   
   # Check for task files
   ls -la *task* *TODO* *issue*
   
   # Ask if unclear: "What system is tracking this task?"
   ```

2. Get the task ID/number from the source system
3. Document the source for updates:
   ```
   TASK_SOURCE_SYSTEM="github"  # or "linear", "jira", "file"
   TASK_SOURCE_ID="#123"  # Issue/ticket number
   ```

### Phase 1: Preparation

**CRITICAL: Gather ALL Relevant Context Files**
1. **Identify context files to include**:
   - PRD files (Product Requirements Documents)
   - SPEC files (Technical Specifications)
   - Design documents
   - API specifications
   - Database schemas
   - Architecture diagrams
   - Related issue/ticket descriptions
   - Any referenced documentation

2. **Read relevant files**:
   ```bash
   # Examples of files to check for and include:
   - */PRD*.md or */prd*.md
   - */SPEC*.md or */spec*.md
   - */requirements*.md
   - */design*.md
   - CLAUDE.md (project conventions)
   - README.md (project overview)
   - Any files mentioned in the task description
   ```

3. **Invoke task-prep-architect WITH FULL CONTEXT**:
   ```
   Prompt: "Prepare implementation for: [task description]
   
   FULL CONTEXT:
   [Include COMPLETE content of ALL PRDs]
   [Include COMPLETE content of ALL SPECs]
   [Include COMPLETE content of ALL design documents]
   [Include COMPLETE content of ALL requirements]
   [Include COMPLETE CLAUDE.md]
   [Include COMPLETE README.md]
   [Include ANY other files mentioned or relevant]
   
   EVERYTHING ABOVE IS PROVIDED TO HELP YOU PREPARE THE IMPLEMENTATION."
   ```

The prep agent will return a TASK-ID in format: `TASK-YYYYMMDD-HHMMSS-<descriptor>`

**Extract the TASK-ID from the output** - Look for:
- "Task ID: TASK-..."
- "### Task ID: TASK-..."
- The TASK-ID in the agent's structured output

**📝 UPDATE EXTERNAL SYSTEM IMMEDIATELY:**
```bash
# GitHub Issue example:
gh issue comment $TASK_SOURCE_ID --body "📋 Task preparation complete
- Task ID: $TASK_ID
- Plan created with [X] implementation cards
- Risk factors identified: [list]
- Starting implementation phase next"

# Linear/Jira: Use appropriate API
# File: Append status to task file
```

### Phase 2: Execution
**Invoke task-executor-tdd WITH the TASK-ID AND FULL CONTEXT**:
```
Prompt: "Implement the task with ID: [TASK-ID from preparation]

FULL CONTEXT:
[Include COMPLETE content of ALL PRDs]
[Include COMPLETE content of ALL SPECs]
[Include COMPLETE content of ALL design documents]
[Include COMPLETE content of ALL requirements]
[Include COMPLETE CLAUDE.md]
[Include COMPLETE README.md]
[Include ANY other files mentioned or relevant]

EVERYTHING ABOVE IS PROVIDED TO HELP YOU WITH THE IMPLEMENTATION."
```

The executor MUST receive:
- The exact TASK-ID to locate the prepared context
- **THE COMPLETE FULL CONTEXT - EVERYTHING**

**📝 UPDATE EXTERNAL SYSTEM AFTER EXECUTION:**
```bash
# GitHub Issue example:
gh issue comment $TASK_SOURCE_ID --body "🔨 Implementation complete
- All [X] cards implemented
- Tests written: [Y] 
- Tests passing: [Y]
- Files modified: [Z]
- Moving to review phase"

# Update labels if applicable:
gh issue edit $TASK_SOURCE_ID --add-label "implemented"
```

### Phase 3: Review
**Invoke task-implementation-reviewer WITH the TASK-ID AND FULL CONTEXT**:
```
Prompt: "Review the implementation for Task ID: [TASK-ID]

FULL CONTEXT:
[Include COMPLETE content of ALL PRDs]
[Include COMPLETE content of ALL SPECs]
[Include COMPLETE content of ALL design documents]
[Include COMPLETE content of ALL requirements]
[Include COMPLETE CLAUDE.md]
[Include COMPLETE README.md]
[Include ANY other files mentioned or relevant]

EVERYTHING ABOVE IS PROVIDED TO HELP YOU REVIEW AGAINST ALL REQUIREMENTS."
```

The reviewer MUST receive:
- The exact TASK-ID
- **THE COMPLETE FULL CONTEXT - EVERYTHING**

**📝 UPDATE EXTERNAL SYSTEM AFTER REVIEW:**
```bash
# If APPROVED:
gh issue comment $TASK_SOURCE_ID --body "✅ Implementation APPROVED
- All requirements met
- Tests passing
- Code quality verified
- Task complete!"
gh issue close $TASK_SOURCE_ID --comment "Completed via $TASK_ID"

# If REWORK NEEDED:
gh issue comment $TASK_SOURCE_ID --body "⚠️ Rework required
- Issues found: [list]
- Returning to implementation phase
- Rework cycle [N]"
```

### Phase 4: Decision & Final Update
- If reviewer returns **APPROVED**: 
  - Task is complete
  - **MUST CLOSE THE EXTERNAL TASK:**
    ```bash
    # GitHub:
    gh issue close $TASK_SOURCE_ID --comment "✅ Completed successfully via $TASK_ID"
    
    # Linear/Jira: Mark as Done/Resolved
    # File: Mark with [COMPLETED] and timestamp
    ```

- If reviewer returns **REWORK NEEDED**: 
  - Go back to Phase 2 (Execution) with the same TASK-ID
  - **UPDATE EXTERNAL SYSTEM** with rework status
  - The executor will see what needs fixing from the review
  - Maximum 3 rework cycles before escalation
  - **UPDATE AFTER EACH REWORK CYCLE**

## Critical Orchestration Rules

**🚨 EXTERNAL SYSTEM SYNCHRONIZATION (HIGHEST PRIORITY):**
- **MUST** identify task source system at the very start
- **MUST** update after EVERY agent completion
- **MUST** include meaningful status information
- **MUST** close/resolve when complete
- **NEVER** proceed to next phase without updating
- **ALWAYS** keep external system as single source of truth

**Context Passing Requirements**:
- MUST identify and read ALL relevant documentation (PRDs, SPECs, etc.)
- MUST pass THE COMPLETE FULL CONTEXT to EVERY SINGLE AGENT
- MUST NOT filter or select - PASS EVERYTHING TO EVERYONE
- EVERY agent gets ALL PRDs, ALL SPECs, ALL docs - COMPLETE
- NO PARTIAL CONTEXT - ALWAYS FULL CONTEXT

**TASK-ID Management**:
- The TASK-ID is the KEY that links all phases
- MUST extract TASK-ID from prep agent output
- MUST pass TASK-ID to executor explicitly
- MUST pass TASK-ID to reviewer explicitly
- NEVER let agents try to "find" the task - tell them which one

**Sequential Execution**:
- Wait for each agent to complete before proceeding
- No parallel execution of phases
- Each agent depends on the previous one's output

**Rework Logic**:
- For MINOR issues: Continue to next task
- For CRITICAL issues: Return to execution (not preparation)
- The same TASK-ID is used throughout all rework cycles
- Preparation is only done ONCE per task

## Example Flow

```markdown
1. User: "Implement user authentication based on auth-PRD.md"

2. You read auth-PRD.md, auth-SPEC.md, CLAUDE.md for context

3. You invoke task-prep-architect:
   Input: "Prepare implementation for: user authentication
   
   PRD REQUIREMENTS:
   [Content from auth-PRD.md]
   
   TECHNICAL SPEC:
   [Content from auth-SPEC.md]
   
   PROJECT CONVENTIONS:
   [Relevant sections from CLAUDE.md]"
   Output: "Task ID: TASK-20240115-143022-auth"

4. You extract: TASK-ID = "TASK-20240115-143022-auth"

5. You invoke task-executor-tdd:
   Input: "Implement the task with ID: TASK-20240115-143022-auth
   
   FULL CONTEXT:
   [COMPLETE auth-PRD.md]
   [COMPLETE auth-SPEC.md]
   [COMPLETE CLAUDE.md]
   [ALL other relevant files - COMPLETE]"
   Output: "Task Execution Complete"

6. You invoke task-implementation-reviewer:
   Input: "Review the implementation for Task ID: TASK-20240115-143022-auth
   
   FULL CONTEXT:
   [COMPLETE auth-PRD.md]
   [COMPLETE auth-SPEC.md]
   [COMPLETE CLAUDE.md]
   [ALL other relevant files - COMPLETE]"
   Output: "APPROVED" or "REWORK NEEDED"

7. If REWORK: Return to step 5 with same TASK-ID and context
```

## Common Mistakes to Avoid

❌ **DON'T**: Pass only the task description without context
✅ **DO**: Include COMPLETE PRDs, SPECs, and ALL documentation to EVERY agent

❌ **DON'T**: Let executor "search" for tasks
✅ **DO**: Pass the exact TASK-ID

❌ **DON'T**: Pass selective or partial context to agents
✅ **DO**: Pass THE COMPLETE FULL CONTEXT to EVERY SINGLE AGENT

❌ **DON'T**: Restart preparation for rework
✅ **DO**: Go back to execution only

❌ **DON'T**: Create new TASK-IDs for rework
✅ **DO**: Use the same TASK-ID throughout

❌ **DON'T**: Run phases in parallel
✅ **DO**: Wait for each to complete

❌ **DON'T**: Assume agents will find context files
✅ **DO**: Explicitly read and pass all relevant files

## Task Completion

When review is APPROVED:
- Mark task as complete
- Remove INPROGRESS labels  
- Document what was implemented
- The context folder remains for audit trail
- **🚨 CRITICAL: CLOSE THE EXTERNAL TASK**
  ```bash
  # GitHub Issue:
  gh issue close $TASK_SOURCE_ID --comment "✅ Task completed successfully
  Implementation ID: $TASK_ID
  Files changed: [list]
  Tests added: [count]
  All requirements met."
  
  # Linear: Mark as Complete
  # Jira: Transition to Done
  # File: Update with [COMPLETED] timestamp
  ```
  
**THE TASK IS NOT DONE UNTIL THE EXTERNAL SYSTEM IS UPDATED AND CLOSED**
