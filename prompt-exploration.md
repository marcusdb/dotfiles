
Workflow prompt

- Sections
    - metadata
    - Workflow (required)
    - Instructions (secondary)
    - Variables (secondary)
    - Report (secondary)
    - relevant files
    - codebase structure


    example

---------------------------------------------------------------------------------------------------
# the prime prompt

---
description: Gain a general understanding of the codebase
---

# Prime
execute the 'Workflow' and 'Report' sections to understand the codebase then summarize your understanding.

## Workflow

- Run 'git ls-files' to list all files in the repository.
- Read 'README.md' for an overview of the project


## Report

Summarize your understanding


---------------------------------------------------------------------------------------------------
# the build prompt
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

---------------------------------------------------------------------------------------------------
# the quick-plan prompt

---
allowed-tools: Read,Write, Edit, Glob, Grep, MultiEdit
description: Creates a concise engineering implementation plan based
argument-hint: [user prompt] 
model: claude-opus-4-1-20250805
---

# Quick Plan

Create a detailed implementation plan based on the user's requirements provided through the "USER_PROMPT variable. Analyze the request, think through the implementation approach, and save a comprehensive specification document to
'PLAN_OUTPUT_DIRECTORY/<name-of-plan>.md' that can be used as a blueprint for actual development work.

## Variables

USER_PROMPT: $ARGUMENTS
PLAN_OUTPUT_DIRECTORY: 'specs/

## Instructions

- Carefully analyze the user's requirements provided in the USER_PROMPT variable
- Think deeply about the best approach to implement the requested functionality or solve the problem
    - Create a concise implementation plan that includes:
    - Clear problem statement and objectives
    - Technical approach and architecture decisions
    - Step-by-step implementation guide
    - Potential challenges and solutions
    - Testing strategy
    - Success criteria
- Generate a descriptive, kebab-case filename based on the main topic of the plan
- Save the complete implementation plan to 'PLAN_OUTPUT_DIRECTORY/<descriptive-name>.md'
- Ensure the plan is detailed enough that another developer could follow it to implement the solution
- Include code examples or pseudo-code where appropriate to clarify complex concepts
- Consider edge cases, error handling, and scalability concerns
- Structure the document with clear sections and proper markdown formatting

## Workflow

1. Analyze Requirements - THINK HARD and parse the USER_PROMPT to understand the core problem and desired outcome
2. Design Solution - Develop technical approach including architecture decisions and implementation strategy
3. Document Plan - Structure a comprehensive markdown document with problem statement, implementation steps, and testing approach
4. Generate Filename - Create a descriptive kebab-case filename based on the plan's main topic
5. Save & Report - Write the plan to 'PLAN_OUTPUT_DIRECTORY/<filename>.md' and provide a summary of key components

## Report
After creating and saving the implementation plan, provide a concise report with the following format:

```
Implementation Plan Created

File: PLAN_OUTPUT_DIRECTORY/<filename>. md
Topic: <brief description of what the plan covers>
Key
Combonents:
- <main component 1>
- <main camponent 2>
- <main component 3>
```

---------------------------------------------------------------------------------------------------
# the creating-image prompt


## Workflow

- First, check your system prompt to make sure you have "mcp replicate_create_models_predictions and 'mcp_replicate get_predictions' available. If not, STOP immediately and ask the user to add them.
- Then check to see if IMAGE_GENERATION_PROMPT' is provided. If not, STOP immediately and ask the user to provide it.
- Take note of 'IMAGE_GENERATION_PROMPT' and "NUMBER_OF_IMAGES'.
- Get the current <date_time> by running 'date +%Y—%m-%d_%H-%M-&S'
- Echo the <date_time>, use this exact value for the output directory name
- Create output directory: 'IMAGE_OUTPUT_DIR/<date_time>/'
- IMPORTANT: Then generate 'NUMBER_OF_IMAGES' images using the 'IMAGE_GENERATION_PROMPT' following the 'image-loop' below.

<image-loop>
    - Use 'mcp_replicate_create_models_predictions' with the MODEL specified above
    - Pass image prompt as the prompt input
    - Lse ASPECT_RATIO for the image dimensions
    - Wait for completion by polling 'mcp_replicateget_predictions
    - Save the executed prompts to 'IMAGE_OUTPUT_DIR/<date_time>/image_prompt_<concise_name_based_on_prompt>.txt'
    - Use the exact prompt that was executed in the 'mcp_replicate_create_models_predictions' call
    - Download the image: IMAGE_OUTPUT_DIR/<date_time>/<MODEL_NAME_underscore_separated>_<concise_name_based_on_prompt>.jpg'
</image-loop>
- After all images are generated, open the output directory: 'open IMAGE_OUTPUT_DIR/<date_time>'



---------------------------------------------------------------------------------------------------
# the parallel agents prompt

## Workflow


2. Design Agent Prompts
    - Create detailed self-contained prompts for each agent
    - Include specific instrusctions on what to accomplish
    - Define clear output expectations
    - Rembember agents are stateless and need complete context

3. Launch Parallel Agents
    - Use the task tool to spawn N agents simultaneously
    - Ensure all agents in a single parallel batch

4. Collect & Summarize Results
    - Gather outputs from all completed agents
    - Synthesize findings into cohesive response.

---------------------------------------------------------------------------------------------------
# the load ai docs prompt

---
description: Load documentation from their respective websites into local markdown files our agents can use as context. 
allowed-tools: Task, WebFetch, Write, Edit, Bash(ls*), mcp_firecrawl-mcp_firecrawl_scrape
---

# Load AI Docs

Load documentation from their respective websites into local markdown files our agents can use as as context. 

## Variables

DELETE_OLD_AI_DOCS_AFTER_HOURS: 24

## Workflow

1. Read the ai_docs/README.md file
2. See any ai_docs/<some-filename>.md file already exists
    1. it does, see if it was created within the last DELETE_OLD_AI_DOCS_AFTER_HOURS" hours
    2. If it was, skip it - take a note that it was skipped
    3. If it was not, delete it - take a note that it was deleted
3. For each url in ai_docs/README.md that was not skipped, Use the Task tool in parallel and use follow the 'scrape_loop_prompt" as the exact prompt for each Task
    <scrape_loop_prompt>
    Use @agent-docs-scraper agent - pass it the url as the prompt 
    </scrape_loop_prompt>
4. After all Tasks are complete, respond in the "Report Format'

## Report Format

```
AI Docs Report:
- <✅ success of ❌failure>: <url> - <markdown file path>
- ...
```

--------
# The background prompt

ーーー
description: Fires off a full Claude Code instance in the background argument-hint: [prompt] [model] [report-file]
allowed-tools: Bash, BashOutput, Read, Edit, MultiEdit, Write, Grep, Glob, WebFetch, WebSearch, Todowrite, Task 
model: claude-opus-4-1-20250805
--- 

# Background Claude Code

Run a Claude Code instance in the background to perform tasks autonomously while you continue working.

## Variables

USER_PROMPT: $1
MODEL: $2 (defaults to 'sonnet' if not provided)
REPORT_FILE: $3 (defaults to './agents/background/background-report-DAY-NAME_HH_MM_SS.md' if not provided)

## Instructions

- Capture timestamp in a variable FIRST to ensure consistency across file creation and references
- Create the initial report file with header BEFORE launching the background agent
- Fire off a new Claude Code instance using the Bash tool with run_in_background=true
- IMPORTANT: Pass the "USER_PROMPT' exactly as provided with no modifications
- Set the model to either 'sonnet' or 'opus' based on "MODEL ' parameter
- Configure Claude Code with all necessary flags for automated operation
- All report format instructions are embedded in the --append-system-prompt
- Use -print flag to run in non-interactive mode
- Use -output-format text for standard text output
- Use -dangerously-skip-permissions to bypass permission prompts for automated operation
- Use allprovided cli flags AS IS. Do not alter them.
- The append-system-prompt contains all report structure requirements and renaming logic
- IMPORTANT: Do not alter the append-system-prompt in any way.

## Workflow

1. Create the report directory if it doesn't exist:
```bash
mkdir -p agents/background
```
2. Set default values for parameters:
    - `MODEL`
    - `TIMESTAMP` (capture once for consistency)
    - `REPORT_FILE` (using the captured timestamp)

3. Create the initial report file with just the header (IMPORTANT: Only IF no report file is provided - if it is provided, echo it and skip this step):

Get this into your context window so you know what to pass into the Claude Code command.
```bash
TIMESTAMP=$(date +%a_&H_&M_%S)
echo "TIMESTAMP: ${TIMESTAMP}"
REPORT_FILE="${REPORT_FILE:-./agents/background/background-report-${TIMESTAMP}…md}"
echo "REPORT_FILE: ${REPORT_FILE}"
echo "# Background Agent Report - ${TIMESTAMP]" > "$(REPORT_FILEJ"
```

<primary-agent-delegation>
4. Construct the Claude Code command with all settings:

- Execute the command using Bash with run_in_background=true
```bash claude \
-model "${MODEL}" \
-output-format text \
-dangerously-skip-permissions \
--append-system-prompt "IMPORTANT: You are running as a background agent. Your primary responsibility is to execute work and document your progress continuously in ${REPORT_FILE. Iteratively write to the report file continuously as you work.
Every few tool calls you should update the REPORT_FILE ## Progress section. Follow this file


## Workflow

IMPORTANT: You MUST follow this workflow as you work:

1. The file ${REPORT_FILE) has been created with a header. You must UPDATE as you proceed it (not recreate it) with this EXACT markdown structure:
```markdown
    # Background Agent Report - DAY-NAME_HH_MM_SS

    ## Task-Understanding
    
    Clearly state what the user requested. Break down complex requests into numbered items:
    User requested:
    1. [First task item]
    2. [Second task-item]
    3. [Next task item]

    ## Progress
    
    IMPORTANT: Document each major step as you work. Update this section as you work:
    - Starting task execution
    - [Action taken with tool/command used]
    - [Finding or observation]
    - [Next action]
    (Keep adding bullets as you work)
    
    ## Results

    List concrete outcomes and deliverables with specific details. Update as you work:
    - [Specific file created/modified with path]
    - [Numeric data or metrics]
    - [Actual accomplishments]

    ## Task Completed (or Task Failed)

    [Final summary - sucçess confirmation or failure explanation]

    ADDITIONAL SECTIONS (add as needed):
    - ## Blockers - Issues preventing progress
    - ## Decisions Made - Important choices and
    - ## Recommendations - FollowUp suggestions
</primary-agent-delegation>    







