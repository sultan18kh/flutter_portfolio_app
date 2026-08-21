---
branch:
target:
commits:
---

<!-- Hard limit: the rendered PR file (this file, filled in) must be 4000 characters or fewer, total. Prioritize the Summary, Commits, and Acceptance Criteria; compress or drop granular per-file bullets in Changes if needed to fit. -->

# <type>: <short PR title>

## Summary

<1-3 sentences: what this PR does and why. Name the playbook/task IDs it implements, if any.>

## Commits

1. `<type>: <commit subject>`
2. `<type>: <commit subject>`

## Changes

### <Area/Task 1> (`<file>`, `<file>`)

- <change>
- <change>

### <Area/Task 2> (`<file>`)

- <change>

## Acceptance Criteria

- [ ] <observable, checkable condition>
- [ ] <observable, checkable condition>
- [ ] `pytest tests/ -v --tb=short` passes with no new failures.

## Test plan

- <automated tests run, pass/fail counts>
- <manual verification steps, if any>
