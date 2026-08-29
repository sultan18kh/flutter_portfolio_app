---
pr: 19
branch: feature/17-listening-reading-widgets
target: main
commits: 40d32e0, bca8897
---

# feat: add listening-to and reading-right-now widgets to About

## Summary

Adds a "My Top Tracks" / "Reading Right Now" card pair to the About section: a real Spotify playlist embed and a live, month-indexed book pick fetched from Open Library. Implements task #17.

## Commits

1. `feat: add listening-to and reading-right-now widgets to About`
2. `feat: make reading-now card tappable, ignore local dev secrets`

## Changes

### Spotify embed (`spotify_embed.dart`, `spotify_embed_web.dart`, `spotify_embed_stub.dart`)

- Conditional export: real `open.spotify.com/embed/playlist` iframe on web via `dart:ui_web` view factory, `url_launcher` link-out fallback elsewhere
- `SpotifyTopTracksCard` renders it at Spotify's 152px compact embed height with logo header

### Reading card (`now_cards.dart`)

- `ReadingRightNowCard` fetches a Work ID from a 12-slot month-indexed list off Open Library's works/authors JSON API, with safe handling of the two description shapes and a missing-pick empty state
- Card body wrapped in `InkWell`, opens the human Open Library work page (not the `.json` endpoint), gated on a successfully loaded title
- Shared `_NowCard` chrome matches bio/education card styling; `now_cards.dart` lays the pair out responsive at the 800px breakpoint

### Wiring (`about_section.dart`, `pubspec.yaml`)

- `nowCards` row/column inserted into `AboutSection`, row on desktop, stacked column below 800px
- Added `http` and `web` package dependencies; added `assets/socials/spotify.svg`

### Misc

- Smoke background burst-in ramp switched to wall-clock elapsed time instead of the looping controller value, avoiding a per-loop reset glitch
- `.gitignore`: ignore local `.dev.vars` (Cloudflare Pages Functions secrets)

## Acceptance Criteria

- [ ] `flutter analyze` passes with no issues
- [ ] Spotify embed renders and plays on web; non-web build falls back to a working link
- [ ] Reading card shows the correct book for the current month, or the empty state when no Work ID is set
- [ ] Tapping the reading card opens the correct Open Library work page in a new tab
- [ ] Both cards match existing bio/education card styling and stack correctly below 800px

## Test plan

- `flutter analyze`: clean
- Manual verification via `flutter run -d chrome` at desktop and sub-800px widths
