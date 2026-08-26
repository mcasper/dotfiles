---
description: Summarize PR review comments and decide what is actionable
---
Find the pull request for the current branch, collect all automated and human review feedback left on it, and decide what needs action.

Use the GitHub CLI when available. Start by identifying the PR for the current branch, then inspect review comments, review bodies, issue comments, relevant automated/bot feedback, and PR checks/statuses. For failing checks, inspect the failure details or linked logs enough to identify whether they are actionable.

Also check whether the branch has merge conflicts with its base branch (via the PR mergeable state and/or a local merge-tree/merge-base check). Treat unresolved merge conflicts as actionable.

Classify each item as:
- Actionable: requires a code, test, documentation, or configuration change
- Not actionable: informational, already resolved, duplicate, stale, passing/duplicate/uninformative CI/status noise, praise, or unrelated discussion
- Needs clarification: potentially valid, but ambiguous or missing enough context to act safely

Present a concise summary with:
1. The PR number/title/URL reviewed
2. Merge conflict status (clean, conflicting files, or unknown) and how to resolve if conflicting
3. Actionable issues, grouped by theme or file, with the proposed fix for each
4. Non-actionable feedback with a short rationale
5. Items needing clarification, including the exact question to ask
6. Recommended implementation order

Do not modify code yet. Stop after presenting the summary and plan unless I explicitly ask you to implement the fixes.
