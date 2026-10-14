---
name: "OPSX: Worktree"
description: "Run a full SDD cycle (propose -> apply -> archive) for one change inside an isolated git worktree, ending in one PR"
category: "Workflow"
tags: ["workflow", "worktree", "sdd", "pr"]
---

Run one complete SDD cycle for the given requirement inside its own git worktree and branch. One change = one worktree = one PR. All work happens in `.trees/<branch-dir>/`, never in the main working directory.

## Steps

1. **Pre-flight** (read-only checks, stop at the first failure):
   - `git status --short`: the main tree must be clean, else tell the user and STOP (one question, wait).
   - `git branch --show-current` must be `main`; `git remote -v` must show `origin`.
   - `.trees/` must be in `.gitignore` (`rg -n '^\.trees/?$' .gitignore`), else STOP and tell the user.
   - Next change number: look at `openspec/changes` and `openspec/changes/archive` (`fd -d1 . openspec/changes openspec/changes/archive`), take the highest `NNN` (archived names are `YYYY-MM-DD-NNN-slug`; read the `NNN` after the date) and add 1, zero-padded to 3 digits. Changes are created in series, never in parallel.

2. **Derive names** from `$ARGUMENTS`: kebab-case `slug` (2-4 words), `change = <NNN>-<slug>`, `type` in `feat|fix|refactor|test|docs|chore`, `branch = <type>/<change>`, worktree dir `.trees/<change>`.

3. **Create the worktree** from `main`:
   ```
   git worktree add .trees/<change> -b <branch>
   ```
   If the branch exists, drop `-b`. If the directory exists, reuse it. Then `cd .trees/<change>` and run `flutter pub get` (a worktree shares no `.dart_tool/` or build output).

4. **Run SDD inside the worktree** (cwd = `.trees/<change>`), one phase at a time, committing at the end of each phase:
   1. **Propose**: `openspec-propose` (it may call `openspec-explore` first if the requirement is vague). Create `openspec new change "<change>"`, then proposal, design, tasks (specs when behavior changes). Commit: `docs(<NNN>): add proposal, design and tasks`.
   2. **Apply**: `openspec-apply-change`. Commit atomically per task group, e.g. `feat(<NNN>): ...`, `test(<NNN>): ...`. Run `flutter analyze` and `flutter test` before every commit; never commit on red.
   3. **Archive**: `openspec-archive-change`. Commit: `chore(<NNN>): archive change`.
   - Pause and ask when a phase reveals a design issue or needs scope beyond the artifacts; update artifacts (`openspec-update-change`) instead of drifting.
   - Keep the scope tight: do exactly what the change defines, no extra code or dependencies.

5. **Rules while working** (from `CLAUDE.md`):
   - Layout and conventions: MVVM with `ChangeNotifier` + `provider`, `go_router`, `lib/{app,data,domain,ui}`, `test/` mirrors `lib/`.
   - Conventional commits only. Never add "Co-Authored-By" or any AI attribution.
   - Code, comments, commits and docs in English. Use `bat/rg/fd/sd/eza`, never `cat/grep/find/sed/ls`.
   - One writer at a time; delegate broad exploration to a sub-agent.
   - Do not push, open the PR or merge on your own.

6. **Hand off the PR** (do not run it): follow the `/commit` command logic from the worktree and share one script block with `git push -u origin <branch>` and `gh pr create` (Why linking the change, What changed, How to test, Notes).

7. **Report** (in Spanish, concise): worktree path, branch, change name, commits made per phase, analyze/test result, the PR script. After the PR is merged, cleanup is manual:
   ```
   git worktree remove .trees/<change>
   git branch -d <branch>
   git pull --ff-only   # on main, before starting the next change
   ```

## User instructions

$ARGUMENTS
