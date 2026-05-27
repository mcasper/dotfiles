---
description: Summarize PR review comments and decide what is actionable
---
Find the pull request for the current branch, collect all automated and human review feedback left on it, and decide what needs action.

Use the GitHub CLI when available. Start by identifying the PR for the current branch, then inspect review comments, review bodies, issue comments, and relevant automated/bot feedback.

Classify each item as:
- Actionable: requires a code, test, documentation, or configuration change
- Not actionable: informational, already resolved, duplicate, stale, CI/status noise, praise, or unrelated discussion
- Needs clarification: potentially valid, but ambiguous or missing enough context to act safely

Present a concise summary with:
1. The PR number/title/URL reviewed
2. Actionable issues, grouped by theme or file, with the proposed fix for each
3. Non-actionable feedback with a short rationale
4. Items needing clarification, including the exact question to ask
5. Recommended implementation order

Do not modify code yet. Stop after presenting the summary and plan unless I explicitly ask you to implement the fixes.
