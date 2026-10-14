# Roadmap

Pending work for the Tyba technical test. Each step is delivered as a numbered OpenSpec change (SDD). Mark items `[x]` when done.

## Done

- [x] `001-setup-project-structure`: folder structure (archived)
- [x] `002-app-shell`: dependencies (`provider`, `go_router`, `http`) and app shell (archived, PR #1)

## Next

- [ ] Data: service + API model + repository with sequential `id` in source order
- [ ] List ViewModel: loading/error/empty/data states, pagination 20 at a time, ListView/GridView toggle
- [ ] Detail: image (gallery/camera), student count with validator, `Info.plist` / `AndroidManifest.xml` permissions
- [ ] Tests: unit (repository, validator, ViewModels), widget (list, detail)
- [ ] README: architecture, decisions, how to run

## Housekeeping

- [ ] Decide the retry UX in the error state (open question in the design)
- [ ] Update `context` in `openspec/config.yaml`: archived changes carry a date prefix before the `NNN` counter
- [ ] Cross-check requirements against the PDF (its text could not be extracted; `pdftotext` is not installed)
- [ ] Try `/commit` in a new chat; add `.trees/` to `.gitignore` before using `/worktree`
- [ ] First commit and public repo (GitHub/GitLab) for delivery
