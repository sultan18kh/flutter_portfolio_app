---
branch: fix/critique-nav-a11y-content-balance
target: main
commits: f8388ed, e93715a, a9200c6, 2045413
---

# feat: nav/a11y polish, hero-about morph, and full hero redesign

## Summary

Implements the full `/impeccable critique` feedback pass plus four rounds of `overdrive`/`bolder` work: fixes scroll-to-section navigation and mobile nav a11y, adds a Hero→About photo morph and scroll progress rail, adds generative project art and a career rail, and closes with a full Hero section redesign (entrance animation, dynamic photo/halo sizing, mobile layout fix).

## Commits

1. `feat: polish nav/section UX and add hero-to-about photo morph`
2. `feat: add project fingerprint art, career rail, and real cert badges`
3. `feat: add copy-to-clipboard contact rows and scroll progress rail`
4. `feat: redesign hero section with entrance animation and mobile fix`

## Changes

### Navigation & accessibility (`navbar_cubit.dart`, `modern_navbar.dart`, `section_keys.dart`)

- Scroll-to-section now uses live navbar height via `RenderAbstractViewport`, fixing overlap and short-landing gaps
- Mobile nav menu rebuilt as height-capped, scrollable, anchored panel with outside-tap dismiss and close-on-scroll
- Reordered nav items to match scroll order; added Certifications entry

### Hero section (`hero_section.dart`, `hero_about_morph.dart`, `photo_morph_progress.dart`, `morph_keys.dart`)

- Removed bio paragraph and CTA buttons (redundant with About; contact-before-portfolio-review avoided)
- Added rotating scanner-halo, cursor glow, signal-tag pills, scroll cue
- Added staggered load-in entrance animation (photo/halo → name → title → pills → scroll cue)
- Fixed height to account for navbar clearance spacer (was pushing scroll cue below the fold)
- Photo/halo now size dynamically off viewport dimensions; mobile-specific sizing/padding added
- Fixed `FittedBox` measuring content at unbounded width (was preventing pill wrap and shrinking photo/halo on narrow screens)
- Added Hero→About profile photo morph driven by live scroll position

### Content sections (`experience_section.dart`, `projects_section.dart`, `certifications_section.dart`, `about_section.dart`, `contact_section.dart`, `socials_section.dart`)

- Generative per-project fingerprint art replacing generic icons
- Scroll-linked filling gradient rail behind Experience badges; seniority-based compact rows
- Real Microsoft badge images wired into Certifications, mapped per credential tier
- Copy-to-clipboard on Contact rows with per-row confirmation text
- Merged Socials into Contact; fixed About Education card width inconsistency
- Contact portrait swapped to cropped caricature (was duplicating About's photo)

### Global (`animated_background.dart`, `scroll_progress_rail.dart`, `app_theme.dart`, `web/`)

- Added page-wide scroll progress rail fixed to viewport top
- Reduced-motion support added to particle background
- Favicon rebuilt in the site's gradient-ring style; stale `favicon.ico` removed

## Acceptance Criteria

- [ ] All nav items (desktop + mobile) scroll to the correct section with no overlap or gap
- [ ] Hero section: entrance animation plays once, no console exceptions, no layout overflow at any viewport width
- [ ] Hero→About photo morph transitions cleanly on scroll
- [ ] Mobile nav menu opens/closes correctly, dismisses on outside tap and scroll
- [ ] `flutter analyze` passes with no issues

## Test plan

- `flutter analyze`: clean across all four commits
- Mechanical design detector (`impeccable/scripts/detect.mjs`): clean on all changed hero/nav files
- Manual verification via local `flutter run -d web-server` + browser: nav routing, hero entrance/morph, mobile-forced layout (breakpoint temporarily overridden for testing, reverted), console checked for exceptions/overflow at each step
