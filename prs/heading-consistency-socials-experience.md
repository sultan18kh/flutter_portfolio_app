---
branch: feat/heading-consistency-socials-experience
target: main
commits: 9502d03
---

# feat: unify section headings, add socials, fix experience layout

## Summary

Follow-up polish pass after the nav/hero redesign PR: unifies every section heading into one shared component, adds WhatsApp and Threads to the socials row, fixes an Experience card layout bug that stretched card height on narrow screens, and gives the Hero halo two independently animated arcs instead of one rigid ring.

## Commits

1. `feat: unify section headings, add socials, fix experience layout`

## Changes

### Section headings (`section_heading.dart`, `about_section.dart`, `skills_section.dart`, `experience_section.dart`, `certifications_section.dart`, `projects_section.dart`, `contact_section.dart`)

- New shared `SectionHeading` widget: gradient accent bar + fixed type scale, always left-aligned via a full-width `SizedBox`+`Align` regardless of the parent's own `crossAxisAlignment`
- Replaced six duplicated `_buildSectionTitle` implementations (previously inconsistent sizes and alignment — some centered, some left, only Certifications had the accent bar)

### Socials (`socials_section.dart`, `assets/socials/whatsapp.svg`, `assets/socials/threads.svg`)

- Added WhatsApp (`wa.me` link from existing phone number) and Threads (icon added; URL left as a placeholder pending the handle)

### Experience card (`experience_section.dart`)

- Root cause: badge (60px) + gap (30px) ate ~40% of a narrow card's width before any text started, forcing the description into a narrow column that wrapped into many lines and stretched card height
- Restructured so the header (badge + title/company/period) stays a Row aligned to the timeline rail, but the description now sits below it spanning the full card width

### Hero halo (`hero_section.dart`)

- Split the single rotating ring into two independently animated arcs (outer/inner), each with its own `AnimationController`, rotating in opposite directions at randomized durations (12–20s outer, 7–13s inner) chosen once per load

## Acceptance Criteria

- [ ] All six section headings render with identical size, accent bar, and left alignment
- [ ] Socials row shows 8 icons; WhatsApp opens `wa.me` link; Threads shows "coming soon" tooltip until a URL is set
- [ ] Experience card description spans the full card width at every viewport size, no excess vertical stretch
- [ ] Hero halo's two arcs visibly rotate in opposite directions at different speeds
- [ ] `flutter analyze` passes with no issues

## Test plan

- `flutter analyze`: clean
- Mechanical design detector (`impeccable/scripts/detect.mjs`): clean on all changed files
- Manual verification via local `flutter run -d web-server` + browser: navigated all six sections confirming heading consistency, verified socials icon row renders without console errors, confirmed Experience card layout and halo rotation live
