---
name: "Commit"
description: "Recommend branch name, commit message and PR structure for the current changes. Shares scripts only; never runs them."
allowed-tools: Bash(git status:*), Bash(git diff:*), Bash(git log:*), Bash(git branch:*), Bash(git rev-parse:*), Bash(fd:*), Bash(eza:*), Bash(rg:*), Bash(bat:*)
category: "Workflow"
tags: ["git", "pr", "commit"]
---

Analyze the current changes and recommend a branch name, commit message(s) and pull request structure. **Share the scripts only: never run `git add`, `git commit`, `git checkout`, `git push` or `gh` yourself.** Read-only git commands are fine.

## Steps

1. **Inspect state** (read-only):
   - `git status --short` and `git branch --show-current`.
   - `git diff --stat` and `git diff --staged --stat`; read the full diff only where the stat is not enough.
   - `git log --oneline -10` for message style. If the repo has no commits yet, say so and skip.
   - Find the related OpenSpec change: active ones via `fd -d1 . openspec/changes`, archived ones via `fd -d1 . openspec/changes/archive`. Use its `proposal.md` for the "why".
   - If there are no changes, say so and STOP.

2. **Recommend a branch name**: `<type>/<NNN>-<slug>`.
   - `type`: `feat`, `fix`, `refactor`, `test`, `docs`, `chore`.
   - `NNN`: the OpenSpec change number when there is one (e.g. `chore/001-setup-project-structure`); omit it otherwise.
   - `slug`: 2-4 lowercase kebab-case words. Skip the suggestion if already on a suitable non-`main` branch.

3. **Recommend commit message(s)**: conventional commits only (`type(scope): summary`, imperative, <= 72 chars, English). Split into several atomic commits when the diff mixes concerns, listing which paths go in each. Never add "Co-Authored-By" or any AI attribution.

4. **Recommend the PR**:
   - **Title:** same style as the main commit.
   - **Description** with these sections: `## Why` (link the OpenSpec change), `## What changed` (bullets), `## How to test` (`flutter analyze`, `flutter test`, manual steps), `## Notes` (tradeoffs, follow-ups; omit if empty).

5. **Share the script**: one fenced `bash` block, in order: create branch, `git add` per commit, `git commit -m`, `git push -u origin <branch>`, and `gh pr create --title ... --body ...`. Use a heredoc for multi-line bodies. Remind the user to run `flutter analyze` and `flutter test` first.

## Output

Respond in Spanish, concise. Code, branch names, commit messages and PR text in English. Order: branch, commits, PR, script.

## User instructions

$ARGUMENTS
