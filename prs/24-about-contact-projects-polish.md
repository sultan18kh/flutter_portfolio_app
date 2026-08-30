---
pr: 24
branch: feature/23-about-contact-projects-polish
target: main
commits: c9f6048, a5e884a
---

# feat: About/Contact/Projects polish, scroll-snap fix, and project detail dialog

## Summary

Polishes the About, Contact, and Projects sections (AlphaBOLD credit/branding, platform badges, richer project link actions), fixes a scroll-snap boundary "leak" caused by trackpad momentum outlasting a fixed release timer, and adds a project details dialog so the previously-unused `Project.features` field is actually surfaced to visitors. Implements task #23.

## Commits

1. `feat: polish About/Contact/Projects sections and fix scroll-snap leak`
2. `feat: add project details dialog and expand technical descriptions`

## Changes

### Scroll-snap fix (`landing_page.dart`, `test/landing_page_scroll_hold_test.dart`)

- Add wheel/trackpad boundary clamp so downward scroll can't skip past a section start
- Replace a fixed 550ms hold-release timer (which fired mid-momentum-tail, letting a residual delta nudge past the boundary) with a debounced release: each event while holding pushes release out by 120ms, capped at a 900ms hard deadline
- Unit test covers the debounce/ceiling arithmetic in isolation

### Project details dialog (`projects_section.dart`, `project.dart`, `project.g.dart`)

- `Project.features` was set on every project but never rendered anywhere — add a pink info button on each card (independent of the card's own hash-derived accent color) opening a dialog with the full description, all technologies, and the complete features list
- Replace `githubUrl`/`liveUrl` with `platforms`, `appStoreUrl`, `playStoreUrl`, `siteUrl`; add platform badges and per-platform link buttons

### Portfolio content (`portfolio_service.dart`)

- Expand technical detail across projects: SOBRsure (BLE hardware comms, spike/false-positive detection, iOS/Android Live Activities, background BLE streaming, multi-admin roles), BOLDHR (resume parsing, JD-vs-resume AI scoring), BOLDAgimble (invoice extraction, automated time entries), BOLDRewards (live social reactions, reward animations), BOLDVelocity (ETL sourcing + Text-to-SQL RAG chat agent); Azure AAD OAuth/CRM-embedded APIs called out across all BOLD-internal products
- Update AlphaBOLD location/bio, rename/reorder project entries, shorten the Healthcare Trademark Compliance Automation Agent description to match other cards' length

### About/Contact (`about_section.dart`, `contact_section.dart`, `modern_navbar.dart`)

- Rename "About" nav item/heading to "Background"; weave an AlphaBOLD employer credit (logo + tappable link) inline into the bio, remove the standalone cover banner image
- Add a tappable Google Maps CID link to Contact's Location field

### Scroll progress rail (`scroll_progress_rail.dart`)

- Add section-position hairline marks along the rail

### Assets

- Remove unused cover banner images, add AlphaBOLD logo asset

## Acceptance Criteria

- [ ] `flutter analyze` passes with no issues
- [ ] Downward wheel/trackpad scroll stops exactly at each section's start, with no visible overshoot even after a strong trackpad flick
- [ ] Every project card with a non-empty `features` list shows a pink info button opening a dialog with full description, technologies, and features
- [ ] "About" nav item and heading read "Background"; bio credits AlphaBOLD inline with logo + link
- [ ] Contact's Location opens the AlphaBOLD Google Maps listing
- [ ] `flutter test` passes with no new failures

## Test plan

- `flutter analyze`: clean
- `flutter test`: all tests pass, including new `landing_page_scroll_hold_test.dart`
- Manual verification via `flutter run -d chrome`: dispatched real `WheelEvent` bursts (including a decaying-delta momentum tail) to confirm the boundary hold lands and releases cleanly; opened the project details dialog from multiple cards and confirmed content/links render correctly
