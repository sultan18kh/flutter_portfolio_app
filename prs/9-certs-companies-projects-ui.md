---
branch: feature/9-certs-companies-projects-ui
target: staging
commits: 2363fbd, 1181b5d, 13cf264
---

# feat: neon theme, certifications/socials sections, and UI craft polish

## Summary

Rebrands the portfolio to a pink/blue neon theme with new photography, adds dedicated Certifications and Socials sections plus company-logo Experience badges, and closes out a full accessibility/performance/craft polish pass (nav routing, mobile overflow, hover jitter, dead-space cards, perf). Resolves #8, #9.

## Commits

1. `feat: apply pink/blue neon theme with new brand photography`
2. `feat: add certifications section, company logos, and resume docs`
3. `feat: polish UI craft, fix nav routing, and add socials section`

## Changes

### Theme & branding (`app_theme.dart`, `animated_background.dart`, `hero/about/contact_section.dart`, `modern_navbar.dart`, `web/`)

- Magenta/cyan neon palette replaces orange/black; particles, gradient rings, favicon/manifest updated to match
- Responsive stacking below 800px added to About/Contact/Navbar; mobile hamburger menu added

### Certifications & Experience (`certifications_section.dart`, `experience_section.dart`, `floating_skill_icon.dart`)

- New CertificationsSection with real Microsoft badge icons, promoted above Projects
- Experience timeline numbers replaced with company-logo badges (pink ring, matches theme)
- FloatingSkillIcon supports raster (PNG/JPEG) assets, not just SVG

### Socials & resume (`socials_section.dart`, `hero_section.dart`, `docs/`)

- New "Find Me Online" section: LinkedIn/GitHub linked, Instagram/Facebook/X placeholders with hand-authored SVGs
- Hero "Get In Touch" opens a pre-filled mailto; "Download CV" downloads the actual resume PDF (renamed for URL-safe serving)

### Nav routing & accessibility (`navbar_cubit.dart`, `section_keys.dart`, `modern_navbar.dart`)

- Replaced stale hardcoded scroll offsets with `Scrollable.ensureVisible` + per-section `GlobalKey`s
- Nav items switched from `GestureDetector` to `InkWell` for keyboard/screen-reader access; `Semantics` labels added to icon-only badges
- Mobile dropdown now opens upward when the navbar is bottom-anchored

### Layout & perf fixes (`reveal_on_scroll.dart`, `projects_section.dart`, `floating_skill_icon.dart`, `hero_section.dart`)

- RevealOnScroll: N per-instance per-frame Tickers replaced with one shared scroll listener
- Projects: `GridView`+fixed aspect ratio (caused dead space) replaced with `Wrap`+intrinsic height
- Fixed Skills hover-label layout jitter and hero CTA overflow on mobile (`Row`→`Wrap`, fixed height→`minHeight`)
- Hero cover image compressed 6.0MB PNG → 44KB WebP

### Content updates (`portfolio_service.dart`, `about_section.dart`)

- Projects: removed BOLDBuild, added NCCN and BOLDVelocity, reordered NCCN/SOBRsure to top
- About Me copy de-duplicated from Hero's paragraph; cover banner hidden on mobile

## Acceptance Criteria

- [ ] Neon theme renders consistently across Hero/About/Skills/Experience/Projects/Contact
- [ ] All nav items (desktop + mobile) scroll to the correct section
- [ ] No layout overflow or jitter at mobile widths (320–400px)
- [ ] Get In Touch / Download CV buttons trigger mailto / PDF download
- [ ] `flutter analyze` passes with no issues

## Test plan

- `flutter analyze`: clean, no issues across all three commits
- Manual verification via local `flutter build web` + browser: nav routing, hover states, mobile viewport, all section content confirmed live
