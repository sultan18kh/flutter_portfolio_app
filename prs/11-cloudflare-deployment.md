---
branch: feature/11-cloudflare-deployment
target: main
commits: bc2cab8, c8aef04, 42a5d13, 2363fbd, 1181b5d, 13cf264
---

# feat: neon rebrand, certs/socials sections, UI polish, and deployment setup

## Summary

First push to `main` since PR #7 — brings everything already live on `staging` (Cubit migration, navbar rebuild, neon theme, certifications/socials sections, full accessibility/perf/craft polish pass) plus new deployment tooling: a `DEPLOYMENT.md` guide and GitHub issue #11 for shipping to `sultankhan.me` on Cloudflare Pages.

## Commits

1. `refactor: migrate from BLoC to Cubit and modularize landing page components`
2. `feat: implement navbar state management and update branding assets`
3. `feat: replace static skill cards with animated floating icon grid`
4. `feat: apply pink/blue neon theme with new brand photography`
5. `feat: add certifications section, company logos, and resume docs`
6. `feat: polish UI craft, fix nav routing, and add socials section`

## Changes

### Architecture (`portfolio_cubit.dart`, `navbar_cubit.dart`, `landing_page.dart`)

- BLoC → Cubit migration; landing page split into modular section widgets
- Nav scroll routing rebuilt on `Scrollable.ensureVisible` + per-section `GlobalKey`s (replaces stale hardcoded pixel offsets)

### Theme & content (`app_theme.dart`, `hero/about/contact_section.dart`, `portfolio_service.dart`)

- Magenta/cyan neon rebrand with new photography; responsive stacking below 800px
- Certifications and Socials sections added; Projects/Experience content updated (real project data, company-logo badges)

### Craft & accessibility polish

- Keyboard/screen-reader access on nav (`InkWell` + `Semantics`), mobile dropdown opens upward when bottom-anchored
- Fixed: Skills hover jitter, Projects card dead space, hero mobile overflow, invisible GitHub icon
- Perf: `RevealOnScroll` moved from N per-frame Tickers to one shared scroll listener; hero image 6MB→44KB

### Deployment (`DEPLOYMENT.md`, GitHub issue #11)

- Step-by-step guide: Cloudflare DNS zone, Pages project (git-integrated or Actions+Wrangler), custom domain + SSL/TLS hardening, security headers
- Domain nameservers already pointed at Cloudflare; Pages project setup in progress

## Acceptance Criteria

- [ ] `flutter analyze` passes with no issues
- [ ] Site renders correctly on `main` matching current `staging` behavior
- [ ] `DEPLOYMENT.md` present at repo root, accurate to the chosen deploy path
- [ ] No regressions in nav routing, responsive layout, or reveal animations

## Test plan

- `flutter analyze`: clean across all six commits
- Manual verification via local `flutter build web` + browser across desktop/mobile viewports (done per-commit during development)
- Post-merge: confirm Cloudflare Pages auto-deploy picks up `main` once connected
