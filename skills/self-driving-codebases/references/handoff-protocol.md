# Handoff Protocol

When a worker completes (or cannot complete) a subtask, it must produce a structured handoff report.

## Handoff Format

```markdown
# Handoff: [Subtask Name]

## Status: [COMPLETE | PARTIAL | BLOCKED]

## Changes Made
- [File]: [What changed]
- [File]: [What changed]

## Verification Results
- [Check]: [PASS | FAIL | SKIPPED]
- [Check]: [PASS | FAIL | SKIPPED]

## Findings
[Relevant discoveries during execution]

## Concerns
[Issues that may affect other subtasks or overall goal]

## Deviations
[Any departures from original subtask scope]

## Recommendations
[Suggested next steps or follow-up work]
```

## Status Definitions

### COMPLETE
- All changes made
- All verifications pass
- No blocking issues

### PARTIAL
- Some changes made
- Some verifications pass
- Remaining work is clear and scoped

### BLOCKED
- Cannot proceed
- Blocking issue identified
- Alternatives proposed

## Examples

### Complete Handoff

```markdown
# Handoff: Create UserSession class

## Status: COMPLETE

## Changes Made
- src/auth/session.ts: Created UserSession class with constructor, isExpired(), refresh()
- src/auth/index.ts: Added export for UserSession

## Verification Results
- TypeScript compiles: PASS
- Instantiation test: PASS

## Findings
- Existing Token class in src/auth/token.ts could be reused for token validation

## Concerns
- None

## Deviations
- None

## Recommendations
- Consider adding UserSession.fromToken() factory method in future subtask
```

### Partial Handoff

```markdown
# Handoff: Implement login endpoint

## Status: PARTIAL

## Changes Made
- src/routes/auth.ts: Created login route structure
- src/routes/auth.ts: Added input validation

## Verification Results
- TypeScript compiles: PASS
- Route responds: PASS
- Actual login logic: SKIPPED (database dependency unclear)

## Findings
- Existing user lookup in src/services/user.ts uses findByEmail()
- Password hashing uses bcrypt (src/utils/crypto.ts)

## Concerns
- Database connection pattern not clear—other routes use different approaches

## Deviations
- Did not implement actual credential checking (blocked on database question)

## Recommendations
- Clarify: Should use existing UserService or direct database access?
- Once clarified, completing login logic is ~10 lines of code
```

### Blocked Handoff

```markdown
# Handoff: Add JWT dependencies

## Status: BLOCKED

## Changes Made
- None (blocked before implementation)

## Verification Results
- N/A

## Findings
- package.json already has 'jsonwebtoken' at version 8.5.1
- Type definitions @types/jsonwebtoken also present

## Concerns
- Subtask was to add dependencies that already exist

## Deviations
- N/A

## Recommendations
- Mark subtask as unnecessary
- Proceed to subtasks that use JWT (dependency already satisfied)
```

## How Planners Use Handoffs

1. **Collect all handoffs** after worker phase
2. **Check statuses**: All COMPLETE? Any BLOCKED?
3. **Review concerns**: Do any affect integration?
4. **Note findings**: Useful context for remaining work
5. **Process deviations**: Need scope adjustment?
6. **Apply recommendations**: Inform next iteration

## Information Propagation

Handoffs are the **only** way workers communicate:
- Workers don't see each other's work directly
- Planner synthesizes handoffs into overall state
- Findings from early workers inform later subtask scoping

This isolation prevents cascade failures—one worker's mistake stays contained.
