# Design

## Context

`StudentCountSection` owns the `TextField`; it already unfocuses on submit (`FocusScope.of(context).unfocus()`). See proposal.md for motivation.

## Goals / Non-Goals

**Goals:**
- Dismiss the keyboard on any tap outside the field.

**Non-Goals:**
- Dismissing on scroll or other fields (there is only one input).
- Saving on blur.

## Decisions

- **`onTapOutside` on the `TextField`** calling the same unfocus used by `_submit`. Local to the widget, no change to the view, covered by the existing widget test file. Tapping Save unfocuses first and then runs `onPressed`, so Save is unaffected.
- Alternative: `GestureDetector(onTap: unfocus)` wrapping the detail with `HitTestBehavior.translucent`. Rejected: couples the screen to a single field and needs a detail-level test.
- Extract a small `_dismissKeyboard()` used by both `_submit` and `onTapOutside` to avoid duplicating the call.

## Risks / Trade-offs

- [`onTapOutside` also fires when a scroll drag starts] → Acceptable, dismissing while scrolling is the usual expected behavior.
