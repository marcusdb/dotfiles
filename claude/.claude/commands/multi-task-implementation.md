Instructions: $ARGUMENTS

Execute all those tasks sequentially, parallelize when possible. Sort the tasks in the proper order against dependencies and pre-conditions.

Do an in depth analysis of which order the tasks should be done and which tasks can be run in parallel

Each task must go through the cycle (preparation, execution, review and results phases and cycle back if needed)

1. **Preparation Phase**: YOU MUST Spawn the task-prep-architect agent using the Task tool to analyze requirements, plan approach, and set up the implementation strategy
2. **Execution Phase**: YOU MUST Spawn the task-executor-tdd agent using the Task tool to perform the actual implementation work using test-driven development
3. **Review Phase**: YOU MUST Spawn the task-implementation-reviewer agent using the Task tool to evaluate the implementation quality and completeness.
4. **Results phase** If any fixes or changes are needed from the REVIEW PHASE, implement then by going through the PREPARATION PHASE and them EXECUTION PHASE and REVIEW PHASE again, if no fixes are needed consider the task complete

**MANDATORY EXECUTION RULES - NEVER SKIP THESE - ABSOLUTELY NON-NEGOTIABLE:**
- You must enforce strict sequential execution - no phase can begin until the previous phase is completely finished
- If the review phase identifies issues requiring rework, you must restart the cycle from preparation through execution to review again


**WORKFLOW MANAGEMENT RULES - ABSOLUTELY NON-NEGOTIABLE - MUST NEVER BE VIOLATED:**
- ALWAYS start with preparation phase using task-prep-architect - NEVER SKIP THIS PHASE
- ALWAYS wait for complete confirmation from each agent before proceeding to the next phase
- If review identifies defects or incomplete work, IMMEDIATELY cycle back to preparation for rework planning
- Continue the preparation-execution-review cycle until the review agent confirms successful completion
- Maintain clear communication about which phase is active and why transitions occur
- Track the number of cycles to identify potential infinite loops and escalate if needed

**Quality Assurance:**
- Ensure each phase agent receives complete context from previous phases
- Verify that rework addresses specific issues identified in reviews
- Confirm that all project-specific requirements from CLAUDE.md are considered throughout the process
- Document the rationale for any cycle restarts

**Communication Protocol:**
- Clearly announce each phase transition
- Summarize key outputs from each completed phase
- Explain the reasoning when cycling back for rework
- Provide status updates on overall implementation progress

Run them sequentially: execute Subagent task-prep-architect  first. After Subagent task-prep-architect completes, run Subagents task-executor-tdd agent and when it completes runs sub agent task-implementation-reviewer - no parallelization

**Task completion and house keeping**
- please make sure to update the task with the work done summary
- please make sure to mark the task as complete and remove any inprogress label
- please make sure to close down the parent task if there is no more open subtasks
