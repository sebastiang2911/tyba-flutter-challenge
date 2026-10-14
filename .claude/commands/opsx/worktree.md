---
name: "OPSX: Worktree"
description: "Implement a requirement in an isolated git worktree, following project guidelines"
category: "Workflow"
tags: ["workflow", "worktree", "isolation"]
---

Create an isolated git worktree for the given requirement and implement it there, never in the main working directory.

## Steps

1. **Derive name**: From `$ARGUMENTS`, build a short kebab-case slug (2-4 words, lowercase and hyphens only). If the request maps to an OpenSpec change, reuse that change name. The slug is both the worktree directory and the branch name.

2. **Pre-flight**:
   - Run `git status --short`. If the main tree is dirty, tell the user and STOP (one question, wait).
   - Ensure `.trees/` is ignored: `rg -n '^/?\.trees/?$' .gitignore`. If missing, append `.trees/` to `.gitignore`.

3. **Create the worktree** (from the current branch):
   ```
   git worktree add .trees/<slug> -b <slug>
   ```
   If the branch already exists, run `git worktree add .trees/<slug> <slug>` (no `-b`). If `.trees/<slug>` already exists, reuse it instead of recreating.

4. **Bootstrap**: `cd .trees/<slug>` and run `flutter pub get`. A worktree does not share `.dart_tool/` or build output with the main tree.

5. **Implement inside `.trees/<slug>/` only**: all edits, tests and commits happen there. Use absolute paths or `cd` first; never touch the main working directory.
   - Follow the project `CLAUDE.md`: layers (data / domain / presentation), Riverpod, loading/error/empty/data states, `flutter_lints`.
   - If the work is an OpenSpec change, use the matching `openspec-*` skill (`apply`, `update`, `sync`, `archive`) with the worktree as cwd.
   - One writer at a time; delegate broad exploration to a sub-agent.
   - Code, comments, commits and docs in English.
   - Use `bat/rg/fd/sd/eza`, never `cat/grep/find/sed/ls`.

6. **Verify before each commit** (inside the worktree): `flutter analyze` and `flutter test` must pass. Report failures with output; never commit on red.

7. **Commit**: conventional commits only (`feat:`, `fix:`, `test:`, `refactor:`, `docs:`, `chore:`). Small, atomic commits. Never add "Co-Authored-By" or any AI attribution. Do not push or merge unless the user asks.

8. **Report** (in Spanish, concise): worktree path, branch, what was done, analyze/test result. Remind that cleanup is manual:
   ```
   git worktree remove .trees/<slug>
   git branch -d <slug>   # after merge
   ```

## User instructions

$ARGUMENTS
