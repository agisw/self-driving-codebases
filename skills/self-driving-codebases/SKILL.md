---
description: "Use when facing complex multi-step tasks requiring decomposition into 5-20 subtasks with parallel worker execution"
---

# Self-Driving Codebases Workflow

This skill implements recursive planning and parallel agent coordination for complex tasks, based on Cursor's multi-agent research.

## When to Use

- Tasks with multiple interconnected components
- Features requiring discovery, design, and implementation phases
- Problems where the full scope isn't immediately clear
- Any work that would benefit from divide-and-conquer decomposition

## Workflow

### Phase 1: Root Planning

Decompose the goal into **5-20 concrete subtasks**:

1. Read the goal and understand the desired outcome
2. Explore the codebase to understand current state
3. Break into independently-verifiable units
4. Each subtask should be:
   - Narrow enough for a single worker
   - Completable without cross-subtask dependencies
   - Verifiable in isolation

**Template for subtask definition:**
```
Subtask N: [Clear action verb] [Specific target]
- Scope: [What files/functions to touch]
- Input: [What information worker needs]
- Output: [What worker should produce]
- Verification: [How to confirm completion]
```

→ **Pause for user approval before proceeding**

### Phase 2: Worker Execution

For each subtask, spawn a worker agent:

```
Use Task tool with:
- subagent_type: sdc-worker
- prompt: [Include subtask definition, scope, and constraints]
```

Workers execute independently:
- No cross-worker communication
- Each reports findings via handoff protocol
- Failures captured, not propagated

→ **Review worker handoffs before synthesis**

### Phase 3: Synthesis

After workers complete:
1. Collect all handoffs
2. Identify:
   - Completed work
   - Concerns or deviations
   - Integration points
3. Verify combined result
4. Iterate if gaps remain

→ **Confirm completion with user**

## Key Principles

### Throughput Over Perfection
- Bias toward completing work
- Surface concerns but don't block on minor issues
- Fix in follow-up commits

### Anti-Fragility
- When stuck, state what's blocking
- Propose alternatives before giving up
- Prefer reversible changes

### Constraints Over Directives
- System prevents bad patterns (via hooks)
- Workers have narrow scope (reduces error surface)
- Explicit handoff protocol (nothing implicit)

## Integration Points

This skill works with:
- **feature-dev**: For discovery and architecture phases
- **superpowers:subagent-driven-development**: For task execution
- **hookify rules**: Guardrails during execution

## Example Usage

```
User: Implement user authentication with JWT
```

**Phase 1 output:**
```
Subtask 1: Add JWT dependencies to package.json
Subtask 2: Create auth middleware in src/middleware/
Subtask 3: Implement login endpoint in src/routes/auth.ts
Subtask 4: Implement token refresh endpoint
Subtask 5: Add protected route wrapper
Subtask 6: Create user session storage
Subtask 7: Write integration tests for auth flow
```

**Phase 2**: Each subtask spawns sdc-worker agent

**Phase 3**: Verify login→token→protected-route flow works end-to-end

## References

- [Planner Prompt](references/planner-prompt.md) - Detailed planning guidance
- [Worker Prompt](references/worker-prompt.md) - Worker agent template
- [Handoff Protocol](references/handoff-protocol.md) - How workers report findings
