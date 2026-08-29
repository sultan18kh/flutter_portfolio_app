---
pr: 22
branch: feature/21-projects-gallery-ui-polish
target: main
commits: 0c82813
---

# feat: add project screenshots, previews, and UI polish

## Summary

Populates the Projects section with real screenshots/scene images for all 6 project cards, adds hover-preview and tap-lightbox interactions, and fixes/polishes several supporting areas of the site (navbar overflow, Hero, Education, and the About "now" cards). Implements task #21.

## Commits

1. `feat: add project screenshots, previews, and UI polish`

## Changes

### Project screenshots & preview (`assets/projects/`, `portfolio_service.dart`, `projects_section.dart`)

- Real screenshot/scene `.webp` per project (originals kept unbundled under `assets/projects/originals/`)
- Card image cropped to a 2:1 header, accent-glow bordered
- Hover (desktop, 220ms intent delay) or tap opens a centered, full-size, uncropped preview/lightbox

### Navbar (`modern_navbar.dart`)

- Fixed overflow at 800-1100px: mobile hamburger breakpoint raised from 800px to 1100px (nav grew from 5 to 7 items), item padding trimmed
- "Projects" label renamed to "Portfolio" to match the section heading

### Hero (`hero_section.dart`, `landing_page.dart`)

- "Scroll to explore" now fades out/in at the same 100px scroll-offset threshold the navbar uses to switch position
- Added "8+ Years Experience" signal pill

### Education (`about_section.dart`)

- Renders the previously-unused `Education.score` field (CGPA/percentage) on each card

### About "now" cards (`now_cards.dart`, `spotify_embed_web.dart`, `about_section.dart`)

- Book cover `Image.network` and the Spotify iframe each show a themed loading indicator instead of appearing blank
- Now-cards row height is measured and matched to the Education column's actual rendered height on desktop; Reading card content vertically centered

### Docs (`PRODUCT.md`, `DESIGN.md`, `.impeccable/design.json`)

- Product context and visual-system documentation for future design work

## Acceptance Criteria

- [ ] `flutter analyze` passes with no issues
- [ ] All 6 project cards show a real screenshot; hover (desktop) and tap (any input) open a centered full-size preview
- [ ] Navbar shows all 7 items with no overflow at any width from 800-1100px; hamburger below 1100px
- [ ] Hero "Scroll to explore" hides once scrolled past the navbar's own switch point, reappears at the top
- [ ] Education cards show their score/CGPA; now-cards row bottom aligns with the Education column's bottom on desktop
- [ ] Book cover and Spotify embed show a loading indicator before content appears, at any network speed

## Test plan

- `flutter analyze`: clean
- Manual verification via `flutter run -d web-server` (both debug and `--release`) at desktop widths (850-1800px) and mobile
- Browser console checked for errors after the release-mode preview crash fix
