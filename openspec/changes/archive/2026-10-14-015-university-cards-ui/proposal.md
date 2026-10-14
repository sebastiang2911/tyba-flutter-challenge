# Proposal

## Why

In list layout, universities render as flat `ListTile`s with no container, while grid layout uses a flat, compact card. The two layouts look unrelated and neither has a clear card affordance.

## What Changes

- List layout items render as elevated, rounded cards with a larger avatar, name, country and a trailing chevron.
- Grid layout items render as taller, vertically centered cards (avatar on top, name and country below), consistent with the list cards.
- Both card styles share the same shape, elevation, surface color and spacing, and keep the avatar/title hero animation to the detail screen.
- Update widget tests for both items.

## Capabilities

### New Capabilities

### Modified Capabilities
- `universities-list`: add a requirement that universities are presented as cards in both layouts.

## Impact

- `lib/ui/features/universities/widgets/university_tile.dart`, `university_card.dart`, `universities_content.dart` (spacing, grid extent).
- `lib/app/theme.dart` (card theme elevation/color, shared by both cards).
- `test/ui/features/universities/widgets/university_tile_test.dart`, `university_card_test.dart`.
- No new dependencies, no data or provider changes.
