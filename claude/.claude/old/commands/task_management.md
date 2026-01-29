---
description: 
globs: 
alwaysApply: true
---
# General Task Creation Definition
  - Tasks should be created using the github tooling (issue, sub-issue, labels and milestones functions)
  - The tooling only allow status to be open or close so use labels for other status
  - Before creating a new label always check if already exists
  - tasks are github issues with no parent and github issues with no parent are tasks, sub-tasks are github issues with parent and vice versa

## Working on tasks
**INPROGRESSLABEL**
- is it mandatory everytime BEFORE YOU ARE GOING to start working on a task to add an INPROGRESS label to the issue/task
- only one issue/task can be INPROGRESS at a time so first check if there is any other issue/task with this label and confirm with the user if he want to start working on the task/issue or continue working on the marked one
- everytime you add this label to a task/issue please remove it form any other task/issues, there can only be one
- When asked which task/issue you are working on please always refer to the one marked with the INPROGRESS label
- when you close the issue remove the INPROGRESS label
- DO NOT UPDATE OR CHANGE THE STATUS OF ANY TASK THAT YOU ARE NOT WORKING ON UNLESS SPECIFICALLY TOLD TO, ONLY CHANGE STATE OR UPDATE THE TASK THAT HAS THE INPROGRESS LABEL


## Task Status Management

- Use label 'status/pending' for tasks ready to be worked on
- Use status 'closed' for completed and verified tasks
- Use label 'status/deferred' for postponed tasks
- Use label 'status/blocked' for tasks that depends on other tasks
- Add custom status values as needed for project-specific workflows
- the INPROGRESS label cannot be at a single task at any given time 
- IMPORTANT: Tasks can only be closed if the test stragety was FULLY IMPLEMENTED and TESTED

## Managing Task Dependencies

- Add a dependency by adding the task/issue number to the "dependencies" array in the task body
- Add a dependency by removing the task/issue number from the "dependencies" array in the task body
- Check and avoid circular dependencies
- Dependencies need to be checked for existence before being added or removed


# Task Creation Guidelines:
  - You are an AI assistant helping to pick a goal/milestone and break down from the milestone specif file at the @milestones folder and also use for reference on Product Requirements Document (PRD) and the memory bank into a set of sequential development tasks. 
  - Make sure to clarify which goal are you going to break down in tasks
  - Create a milestone for this goal
  - Make sure to call add-sub-issue tool to the link the sub-task to the task
  - Your goal is to create 10 well-structured, actionable development tasks based on the PRD provided and the memory bank and the request itself
  - Each task should be atomic and focused on a single responsibility
  - Order tasks logically - consider dependencies and implementation sequence
  - Early tasks should focus on setup, core functionality first, then advanced features
  - Include clear validation/testing approach for each task
  - Set appropriate dependency IDs
  - Assign priority (high/medium/low) based on criticality and dependency order
  - If the PRD contains specific requirements for libraries, database schemas, frameworks, tech stacks, or any other implementation details, STRICTLY ADHERE to these requirements in your task breakdown and do not discard them under any circumstance
  - Focus on filling in any gaps left by the PRD or areas that aren't fully specified, while preserving all explicit requirements 
  - Always aim to provide the most direct path to implementation, avoiding over-engineering or roundabout approaches
  - Include detailed implementation guidance in the "details" field 
  - Each task should follow this structure (should be created using the github tooling, please create the labels if needed):
    - id: it will be provided by the tool when created
    - number: also provided by the tool when created
    - title: Short and concise task summary
    - body: 
      - description: string - detailed task description
      - dependencies: number [] (numbers of the tasks this depends on)
      - details: string (implementation details)
      - testStrategy: string (validation approach)
    - status: open
    - milestone: the milestone created for the goal this task belongs to
    - labels: "status/pending" or "status/blocked" and "priority/high or priority/medium or priority/low"


# Task BreakDown (Subtasks) Guidelines:
  - You are an AI assistant helping to break down a given open task into a set of sequential development tasks. 
  - Your goal is to create 3 well-structured, actionable development tasks based on the PRD provided.
  - Make sure to clarify which task  are you going to break down in sub- tasks
   - Each task should be atomic and focused on a single responsibility
  - Order tasks logically - consider dependencies and implementation sequence
  - Early tasks should focus on setup, core functionality first, then advanced features
  - Include clear validation/testing approach for each task
  - Set appropriate dependency IDs
  - Assign priority (high/medium/low) based on criticality and dependency order
  - If the PRD contains specific requirements for libraries, database schemas, frameworks, tech stacks, or any other implementation details, STRICTLY ADHERE to these requirements in your task breakdown and do not discard them under any circumstance
  - Focus on filling in any gaps left by the PRD or areas that aren't fully specified, while preserving all explicit requirements 
  - Always aim to provide the most direct path to implementation, avoiding over-engineering or roundabout approaches
  - Include detailed implementation guidance in the "details" field 
  - Each task should follow this structure (should be created using the github tooling, please create the labels if needed):
    - id: it will be provided by the tool when created
    - number: also provided by the tool when created
    - title: Short and concise task summary
    - body: 
      - description: string - detailed task description
      - dependencies: number [] (numbers of the tasks this depends on)
      - details: string (implementation details)
      - testStrategy: string (validation approach)
    - status: open
    - milestone: the milestone created for the goal this task belongs to
    - labels: "status/pending" or "status/blocked" and "priority/high or priority/medium or priority/low" and "SUB-TASK"

## Task Complexity Analysis
  -   Analise the current goal tasks and also rank them between 1-10 complexity
  -   Create a complexity report in the memory-bank folder
  -   Focus on tasks with highest complexity scores (8-10) for detailed breakdown
  -   Use analysis results to determine appropriate subtask allocation

  

