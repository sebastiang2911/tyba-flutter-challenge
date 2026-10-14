# Design

## Context

Routes: `/` (list) and `/university/:id` (detail), both top-level `GoRoute`s. The list calls `context.go(AppRoutes.detailFor(id))`, which replaces the stack. The list ViewModel is app-scoped (`provider` in `app.dart`), so its state outlives the list view. See proposal.md for motivation.

## Goals / Non-Goals

**Goals:**
- Back from the detail lands on the list in both stack and deep-link cases.

**Non-Goals:**
- Nested routes or restructuring the router.
- Changing state management (planned in `009-migrate-to-riverpod`).

## Decisions

- **`context.push` from the list.** Keeps the list in the stack, so the default AppBar back arrow and the system back gesture pop normally and the list view keeps its scroll position. Alternative: keep `go` and add a manual back everywhere; rejected, it fights the framework.
- **Fallback when nothing to pop.** In the detail, a `BackButton` whose `onPressed` is `context.canPop() ? context.pop() : context.go(AppRoutes.list)`, and `PopScope(canPop: context.canPop(), onPopInvokedWithResult: ...)` that does `context.go(AppRoutes.list)` when it cannot pop. Alternative: make the detail a child route of `/` so go_router builds the stack itself; rejected as a larger router change for one edge case (deep link), and it would change URLs/tests.
- **Logic stays in the View/router layer.** It is pure navigation, no ViewModel change.

## Risks / Trade-offs

- [`PopScope` API differs by Flutter version (`onPopInvoked` vs `onPopInvokedWithResult`)] -> use the one available in the installed SDK and cover with a widget test.
- [Pushing the same detail repeatedly stacks pages] -> not reachable from the current UI (detail has no links to other details).
