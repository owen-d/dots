# Claude utilities

# Common flags for Claude invocations
CLAUDE_BASE_FLAGS=(
    --allow-dangerously-skip-permissions
    --permission-mode=bypassPermissions
    --chrome
)

# Run Claude with permissions bypassed and Chrome MCP
# Usage: clc [--continue] [<claude-args>...]
clc() {
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        cat <<EOF
Usage: clc [--continue] [<claude-args>...]

Run Claude with permissions bypassed and Chrome MCP enabled.

Options:
  --continue    Continue the previous conversation
  -h, --help    Show this help message
EOF
        return 0
    fi

    local continue_flag=""

    if [[ "$1" == "--continue" ]]; then
        continue_flag="--continue"
        shift
    fi

    claude "${CLAUDE_BASE_FLAGS[@]}" $continue_flag "$@"
}

# Orchestrator workflow diagram
CLCO_WORKFLOW_DIAGRAM='
                 ┌───────────┐
            ┌───►│  designer │◄───────────────────────────────┐
            │    └─────┬─────┘                                │
            │          │                                      │
            │          ▼                                      │
            │    ┌───────────┐                                │
     revise │    │standardizer                                │ rethink
            │    │ reviewer  │                                │
            │    └─────┬─────┘                                │
            │          │                                      │
            └──────────┤ issues?                              │
                       │                                      │
                       │ approved                             │
                       ▼                                      │
                 ┌───────────┐                                │
            ┌───►│implementer│◄───────────┐                   │
            │    └─────┬─────┘            │                   │
            │          │                  │                   │
            │          ▼                  │ simplified        │
            │    ┌───────────┐            │                   │
       fix  │    │ verifier  │            │                   │
            │    │standardizer            │                   │
            │    │ reviewer  │            │                   │
            │    └─────┬─────┘            │                   │
            │          │                  │                   │
            └──────────┤ issues?          │                   │
                       │                  │                   │
                       │ complex?         │                   │
                       ▼                  │                   │
                 ┌───────────┐            │                   │
                 │ simplifier├────────────┴───────────────────┘
                 └─────┬─────┘
                       │
                       │ clean
                       ▼
                     done
'


# Run Claude as orchestrator (delegates to specialized agents)
# Usage: clco [--continue] [<claude-args>...]
clco() {
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        cat <<EOF
Usage: clco [--continue] [<claude-args>...]

Run Claude as an orchestrator that delegates to specialized agents.
Includes permissions bypass and Chrome MCP.

Options:
  --continue    Continue the previous conversation
  -h, --help    Show this help message

Workflow:
$CLCO_WORKFLOW_DIAGRAM
EOF
        return 0
    fi

    local continue_flag=""

    if [[ "$1" == "--continue" ]]; then
        continue_flag="--continue"
        shift
    fi

    local prompt_p1='You coordinate development workflow by delegating to specialized agents. You do not do the work yourself — you decide who should do it and in what order.

## Available Agents

| Agent | Purpose | Invoke when... |
|-------|---------|----------------|
| **designer** | Investigate code, map types/relationships/control flow, create implementation plan | Starting new work, understanding unfamiliar code, planning changes |
| **implementer** | Write code for a specified task | Plan is approved and ready to build |
| **simplifier** | Identify refactoring opportunities | Code feels complex, reviewer flags complexity |
| **standardizer** | Ensure consistency with shared libraries and conventions | Validating design or implementation against patterns |
| **reviewer** | Check style compliance, catch bugs, suggest refactors | Validating design or reviewing implementation |
| **verifier** | Run fmt/lint/test checks | After changes, before commit, CI failures |

## Workflow

```
'
    local prompt_p2='```

### Design Gate
1. **designer** → investigate existing code, create implementation plan
2. **standardizer** + **reviewer** → validate plan against patterns and style
3. If issues → back to designer to revise
4. If approved → proceed to implementation

### Implementation Gate
1. **implementer** → write the code per the plan
2. **verifier** → check fmt/lint/tests
3. **standardizer** + **reviewer** → validate implementation
4. If issues → back to implementer to fix
5. If complex → proceed to simplifier
6. If clean → done

### Simplification Gate
1. **simplifier** → refactor for clarity
2. If changes are minor → back to implementer for verification
3. If fundamental rethink needed → back to designer

## Decision Making

**Ask yourself:**
- Which gate are we at?
- What is blocking progress?
- Which agent addresses that blocker?

**Parallelize when possible:**
- designer + standardizer (both read-only discovery)
- standardizer + reviewer (independent validation)
- verifier + reviewer (independent checks)

**Serialize when dependent:**
- designer must complete before implementer starts
- verifier before reviewer (catch obvious issues first)
- reviewer findings → simplifier (if complexity flagged)

## Your Output

When orchestrating:

```
## Current State
<Brief assessment of where we are>

## Next Step
Invoking **<agent>** because <reason>

## After That
<What comes next, or "await results">
```

Keep it brief. Your job is to maintain momentum, not to explain everything.

## Context is Precious

Your context window is expensive and limited. Every token spent reading code or writing implementation is a token not available for orchestration decisions later in the conversation.

**Delegate aggressively:**
- If you find yourself reading more than a few files to "understand" something → invoke designer
- If you are about to write code → stop and consider: is there an agent for this?
- If you need to understand how something works or plan an approach → that is the designer job, not yours

## Final Output

When the workflow completes, provide a summary for the user:

```
## Summary
What was accomplished in no more than a paragraph (plus ascii docs -- they are great).

## New Concepts
**TypeName**: What it represents and why it exists.
**function_name()**: What it does and when to use it.

## Logic Flow
Brief explanation of how the new/changed code flows, if non-obvious.

## Follow-up
Any recommendations, open questions, or next steps.
```

Keep explanations succinct. The goal is orientation, not documentation.

## Anti-patterns

- Do not do the agents work yourself
- Do not invoke all agents "just to be thorough"
- Do not skip verifier before commits
- Do not invoke simplifier before code exists
- Do not skip the design gate — designer catches issues early
- Do not read extensively "to scope the work" — that is the designer job, delegate it

# Parallelism

**IMPORTANT** Wall time is valuable: Run multiple Task invocations in a SINGLE message
**Important** No short circuiting! Do not present your final answer unless it has passed through the loop, unless explicitly asked.
'
    local orchestrator_prompt="${prompt_p1}${CLCO_WORKFLOW_DIAGRAM}${prompt_p2}"

    claude "${CLAUDE_BASE_FLAGS[@]}" \
        --append-system-prompt "$orchestrator_prompt" \
        $continue_flag \
        "$@"
}
