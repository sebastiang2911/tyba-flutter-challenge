# Proposal

## Why

The list opens the detail with `context.go(...)`, which replaces the navigation stack. The detail has no history, so the AppBar shows no back arrow and the system back gesture closes the app instead of returning to the universities list.

## What Changes

- Open the detail with `context.push(...)` so the list stays below it in the stack.
- The detail shows a back button that pops to the list; when there is nothing to pop (deep link straight to `/university/:id`), it navigates to the list instead.
- The system back gesture follows the same behavior.
- Tests cover back from the detail (stack case and deep-link case).

## Capabilities

### New Capabilities

None.

### Modified Capabilities

- `university-detail`: adds a requirement that back from the detail returns to the universities list.

## Impact

- `lib/ui/features/universities/views/universities_list_view.dart` (`go` -> `push`).
- `lib/ui/features/universities/views/university_detail_view.dart` (back fallback).
- Tests: `test/ui/features/universities/views/` (list and detail view tests).
- No new dependencies; the list ViewModel is app-scoped, so list state (page, layout) survives the round trip.
