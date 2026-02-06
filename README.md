# Self-Driving Codebases Plugin

Multi-agent workflow for complex task decomposition with recursive planning, parallel workers, and anti-fragility patterns.

Based on [Cursor's research on multi-agent coding](https://www.cursor.com/blog/self-driving-codebases).

## Philosophy

This plugin implements three core principles:

1. **Throughput over Perfection** - Bias toward completing work; surface concerns but don't block on minor issues
2. **Constraints over Directives** - System prevents bad patterns via hooks rather than relying on reminders
3. **Anti-Fragility** - When stuck, state what's blocking and propose alternatives; failures are captured, not propagated

## Installation

### Method 1: Direct Clone to Plugins Directory

```bash
git clone https://github.com/jh822/self-driving-codebases ~/.claude/plugins/self-driving-codebases
```

The plugin loads automatically from `~/.claude/plugins/`.

### Method 2: Clone + Symlink (for Development)

```bash
# Clone to your preferred location
git clone https://github.com/jh822/self-driving-codebases ~/projects/self-driving-codebases

# Install via symlink
cd ~/projects/self-driving-codebases
./scripts/install.sh
```

### Method 3: Development Mode (Temporary)

```bash
claude --plugin-dir /path/to/self-driving-codebases
```

## Uninstallation

```bash
# If installed via symlink
cd ~/.claude/plugins/self-driving-codebases
./scripts/uninstall.sh

# Or simply remove the directory/symlink
rm -rf ~/.claude/plugins/self-driving-codebases
```

## Usage

Invoke the skill when facing complex multi-step tasks:

```
/self-driving-codebases
```

Or reference it in conversation:

```
User: I need to implement user authentication with JWT. Use the self-driving codebases workflow.
```

### Workflow Phases

#### Phase 1: Root Planning

The planner decomposes your goal into 5-20 concrete subtasks:

```
Subtask 1: Add JWT dependencies to package.json
Subtask 2: Create auth middleware in src/middleware/
Subtask 3: Implement login endpoint in src/routes/auth.ts
...
```

Each subtask includes:
- **Scope**: Files/functions to touch
- **Input**: Information worker needs
- **Output**: What should exist when done
- **Verification**: How to confirm completion

**You approve the plan before execution.**

#### Phase 2: Worker Execution

Workers (via `sdc-worker` agent) execute subtasks independently:
- No cross-worker communication
- Each reports findings via handoff protocol
- Failures are captured and reported, not propagated

#### Phase 3: Synthesis

After workers complete:
1. Handoffs are collected and reviewed
2. Integration points are verified
3. Gaps trigger iteration if needed

## Components

### Skill: self-driving-codebases

Main entry point. Orchestrates the planning-execution-synthesis workflow.

Location: `skills/self-driving-codebases/SKILL.md`

### Agent: sdc-worker

Executes individual subtasks with narrow focus. Reports via structured handoff protocol.

Location: `agents/sdc-worker.md`

Features:
- Narrow scope enforcement
- Anti-fragility patterns (reports when stuck)
- Structured handoff format

### Hooks

Active guardrails during execution:

| Hook | Event | Purpose |
|------|-------|---------|
| Verification Reminder | Stop | Prompts checklist before session end |
| Large Task Warning | UserPromptSubmit | Suggests decomposition for complex tasks |
| Placeholder Detection | PreToolUse | Warns against TODO/FIXME patterns |

## Reference Documents

- `skills/self-driving-codebases/references/planner-prompt.md` - Detailed planning guidance
- `skills/self-driving-codebases/references/worker-prompt.md` - Worker agent template
- `skills/self-driving-codebases/references/handoff-protocol.md` - How workers report findings

## Integration

Works well with other Claude Code features:

- **feature-dev plugin** - Use code-explorer for discovery phase
- **superpowers plugin** - Complements subagent-driven-development
- **hookify plugin** - Additional custom guardrails

## Contributing

1. Fork the repository
2. Create a feature branch
3. Submit a pull request

## License

MIT License - see [LICENSE](LICENSE)
