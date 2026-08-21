---
branch: feature/6-floating-icons-skills-section
target: main
commits: 42a5d13
---

# feat: replace static skill cards with animated floating icon grid

## Summary

Replaces the static `GridView` of skill cards in the Skills section with an animated `SkillsGrid` of floating, hover-reactive SVG icons. Implements task #6.

## Commits

1. `feat: replace static skill cards with animated floating icon grid`

## Changes

### Skills UI (`lib/widgets/floating_skill_icon.dart`, `lib/widgets/skills_grid.dart`, `lib/widgets/sections/skills_section.dart`)

- Add `FloatingSkillIcon`: per-icon float/rotate/scale animation with hover state, rendered via `flutter_svg`
- Add `SkillsGrid`: responsive `Wrap` layout over 13 SVG skill icons in `assets/skills/`
- Rewrite `SkillsSection` to render `SkillsGrid` instead of the old `GridView` skill cards + `Icons` mapping

### Landing page (`lib/pages/landing_page.dart`)

- Reorder sections: Skills now renders before Experience/Projects

### Dependencies & assets (`pubspec.yaml`, `assets/skills/`)

- Bump `flutter_bloc` to `^9.1.1`, `go_router` to `^16.2.4`, `flutter_lints` to `^6.0.0`
- Add `flutter_svg` dependency
- Add 13 skill SVG icons and register `assets/skills/` in the asset bundle

### Docs & tooling (`CLAUDE.md`, `USAGE.md`, `graphify-out/`, `.gitignore`)

- Add `CLAUDE.md` (architecture guide) and `USAGE.md` (run instructions)
- Add `graphify-out/` knowledge graph artifacts (report, graph.json, graph.html)
- Untrack `.DS_Store`; ignore it plus graphify's local/cache files

## Acceptance Criteria

- [ ] Skills section renders the floating SVG icon grid instead of static cards
- [ ] Each icon floats/rotates/scales continuously and reacts to hover (name label, glow, border)
- [ ] Skills section appears before Experience section on the landing page
- [ ] `flutter analyze` passes with no new issues
- [ ] `flutter test` passes with no new failures

## Test plan

- `flutter analyze` — manual run required, not yet executed in this session
- `flutter test` — manual run required, not yet executed in this session
- Manual: `flutter run -d chrome`, scroll to Skills section, verify float animation and hover states on each icon
