---
target: portfolio landing page (lib/pages/landing_page.dart)
total_score: 15
max_score: 32
na_heuristics: 7,10
p0_count: 3
p1_count: 2
timestamp: 2026-08-28T13-14-18Z
slug: lib-pages-landing-page-dart
---
Method: dual-agent (A: general-purpose · B: general-purpose)

## Design Health Score

| # | Heuristic | Score | Key Issue |
|---|-----------|-------|-----------|
| 1 | Visibility of System Status | 2/4 | No loading skeleton; contact rows give no tappable affordance |
| 2 | Match System / Real World | 1/4 | Navbar order doesn't match actual scroll order |
| 3 | User Control and Freedom | 1/4 | Mobile menu has no scrim/Esc/outside-tap dismiss — confirmed stuck open through scroll + blank-tap |
| 4 | Consistency and Standards | 2/4 | Nav lists 6 items, page has 8 sections — Certifications & Socials unreachable from nav |
| 5 | Error Prevention | 2/4 | Hero bio hard-clipped at `maxLines: 4`, no ellipsis — confirmed cut mid-sentence on 390px |
| 6 | Recognition Rather Than Recall | 3/4 | Section titles/iconography consistent, scroll-spy works |
| 7 | Flexibility and Efficiency | n/a | Single-audience persuade-mode site, no power-user path expected |
| 8 | Aesthetic and Minimalist Design | 2/4 | Certification info repeated 3x; About column badly unbalanced (dead whitespace ~1 viewport tall) |
| 9 | Error Recovery | 1/4 | `PortfolioError` state is a dead end — no retry action |
| 10 | Help and Documentation | n/a | Not applicable to a portfolio |
| **Total** | | **15/32** | **Poor (47%)** |

## Design Specificity Verdict

**LLM assessment**: Not a template with names swapped — the "$10M-seed IoT safety platform" line, NCCN healthcare-compliance work, six named Microsoft certs, and real company logos (AlphaBOLD, Confiz, Netsol) are genuinely Sultan's. But execution undercuts it: every Project card wraps in the same generic Material icon on a gradient banner with zero relation to the actual work, the Skills grid is an interchangeable floating-icon layout, and entry-level "Fundamentals" certs get equal or greater visual weight than the senior work history — a positioning mismatch for someone titled "Senior AI Solutions Developer."

**Deterministic scan**: The CLI detector (`detect.mjs`) returned `[]`/exit 0, and browser-injected `detect-antipatterns-browser.js` also returned 0 findings — **neither is a clean pass**. Root cause, confirmed by reading detector source: `.dart` isn't in `SCANNABLE_EXTENSIONS`, and the app renders into a single `<canvas>` three shadow-DOM layers deep (`flt-glass-pane` → `flt-scene-host` → `flt-canvas-container`), so a CSS/DOM-based detector has nothing to inspect — colors, spacing, and typography all live inside canvas paint calls, invisible to both tools. Treat both `[]` results as "no signal," not "no problems."

**Visual overlays**: No in-page overlay could be produced (same canvas-opacity reason above) — no reliable user-visible overlay exists for this app in its current rendering mode; this is a tooling ceiling, not a claim about the design.

**What the mechanical pass caught that the design review didn't**: a reproducible layout bug — navigating to "About" via the navbar lands the fixed pink/magenta nav bar **on top of** page content: it visibly overlaps the bottom of a profile thumbnail, covers part of the "$10M-seed IoT..." paragraph, and truncates the top of the "Bachelor of Science" heading. This matches this repo's own CLAUDE.md note that `NavbarCubit.scrollToSection` uses **hardcoded pixel offsets per section** that under-account for navbar height on at least this section. Also confirmed: the mobile hamburger overlay is semi-transparent, so "SULTAN KHAN" hero text and the "Contact" menu row are simultaneously legible, layered on top of each other.

**Also confirmed, unrelated to design quality**: `localhost:9100` (assumed live during this session) was actually serving the Dart DevTools connect screen, not the portfolio — the real app was reachable at `localhost:9877`. Flagging so future runs don't assume the port without checking; dev-server ports drift session to session.

## Overall Impression

The visual identity (neon magenta/cyan on near-black, custom About illustration, real company-logo badges) is distinctive and clearly authored for this person — this isn't a Bootstrap-template portfolio. But the site is undermined by concrete, reproducible defects rather than taste: a navbar that physically covers content on at least one section, a nav menu whose order doesn't match the page it navigates, hero copy that gets silently cut off on mobile, and a mobile dropdown that won't close. The single biggest opportunity: fix the scroll-offset/nav-order mismatch first — it's the kind of bug a recruiter hits in the first 15 seconds, before any of the genuinely good work (the custom illustration, the company-logo timeline) gets a chance to land.

## What's Working

1. **The custom About-section illustration** — a bespoke Flutter/Apple/Python/Azure panel piece around a seated-developer figure. No template ships this; it does real work signaling "AI + mobile" identity.
2. **Company-logo badges in Experience** (`_companyLogos` map with real AlphaBOLD/Confiz/Netsol/FFC assets, icon fallback) — a low-cost, high-authenticity touch over a generic numbered timeline.
3. **The neon magenta/cyan-on-black palette** is consistently applied through gradients, borders, and shadows — reads as a deliberate identity, not default Material dark theme.

## Priority Issues

**[P0] Fixed navbar overlaps page content after scroll-to-section navigation.**
Why it matters: Confirmed via screenshot — clicking "About" in the navbar lands the opaque nav bar directly over a profile thumbnail, a body paragraph, and the top of the "Bachelor of Science" heading. This is a hard functional defect a visitor hits by clicking the very first nav link, not a taste issue.
Fix: `NavbarCubit`'s hardcoded per-section pixel offsets (see `lib/blocs/navbar_bloc/navbar_cubit.dart`) need to subtract the actual navbar height (plus safe margin) for every section, not just some — audit each offset against rendered navbar height, ideally by measuring it via a `GlobalKey` instead of a hardcoded constant.
Suggested command: `/impeccable audit`

**[P0] Navbar order doesn't match actual scroll order; two sections are unreachable from nav.**
Why it matters: `modern_navbar.dart` lists `Home, About, Experience, Projects, Skills, Contact` but the page renders `Hero, About, Skills, Experience, Certifications, Projects, Contact, Socials`. Clicking "Experience" expects it before "Projects," but Skills comes first; Certifications and Socials have no nav entry at all. Breaks the user's mental model on the very affordance meant to build it.
Fix: Reorder `_navItems` to match actual render order, and add entries for Certifications and Socials (or fold Socials into Contact — see below).
Suggested command: `/impeccable layout`

**[P0] Hero bio text is silently truncated on narrow viewports.**
Why it matters: `hero_section.dart`'s `AutoSizeText(personalInfo.profile, maxLines: 4)` cuts the sentence at "...$10M" on a 390px viewport with no ellipsis or overflow indicator — the closing clause about healthcare-compliance automation, the most differentiating detail, is silently lost.
Fix: Shorten the source bio to reliably fit 4 lines across breakpoints, or add `TextOverflow.ellipsis` so truncation is at least visible, or raise `maxLines` on narrow widths.
Suggested command: `/impeccable adapt`

**[P1] Mobile nav dropdown has no dismiss path except selecting an item, and bleeds through onto hero content.**
Why it matters: Confirmed empirically — opening the hamburger menu and scrolling 40+ ticks or tapping blank canvas leaves it open. Separately confirmed the overlay panel is semi-transparent: the "Contact" menu row and "SULTAN KHAN" hero heading are simultaneously legible, layered on top of each other.
Fix: Add a scrim `GestureDetector` covering the rest of the screen to close on outside tap, close on scroll-controller movement, and raise the overlay's background opacity so menu text doesn't compete with content behind it.
Suggested command: `/impeccable polish`

**[P1] Certifications shown three times; Experience gives an "IT Intern" bullet the same visual weight as the current senior role.**
Why it matters: Cert badges appear in the hero cover banner, as floating badges, and again as a 6-card grid — three repetitions of the same fact, skewed toward entry-level "Fundamentals" badges. Meanwhile Experience renders all 6 roles as equal-size cards, so a one-bullet 2017 internship reads with the same prominence as the current AlphaBOLD role. For a "Senior AI Solutions Developer" title, this flattens the seniority signal a recruiter is scanning for.
Fix: Collapse Certifications to one representation (badges *or* card grid, not both). Differentiate Experience card sizing/detail by recency/seniority, or compress the older one-line internships into a single compact row.
Suggested command: `/impeccable distill`

## Persona Red Flags

**Jordan (recruiter, first-time visitor, ~30s)**: Lands on Hero, reads a bio that ends mid-sentence at "$10M" — may read as broken rather than truncated. Clicks "Experience" in nav expecting it next, but actually skips past Skills — mismatched mental model. Scrolls to the end looking for a "hire me" moment and instead hits a bare row of social icons.

**Riley (stress-tester)**: Opens the mobile hamburger menu, tries to dismiss by tapping the page or scrolling — doesn't close (confirmed). Also finds the `PortfolioError` state (`landing_page.dart` lines 65-83) has no retry button — a dead end if the mock data load ever failed for real.

**Casey (distracted mobile user)**: Skims hero on phone, sees the abruptly cut-off bio, taps "Get In Touch" (works, opens mailto) — but if they scroll first they get 6 full-height Experience cards and 6 Certification cards before reaching a plain-text Contact block, then trail into disconnected social icons with no clear stopping point.

## Minor Observations

- `AnimatedBackground`'s 50-particle canvas repaints every frame for the app's full lifetime — battery cost, no reduced-motion handling for floating icons or particles.
- `cert.issuer ?? 'Unknown Issuer'` fallback would look broken in production; better to omit the issuer line entirely if null.
- `FloatingSkillIcon`'s `Semantics(label: skillName)` is good practice, but the tooltip only shows on hover — keyboard/touch users without a mouse never see the skill name, the exact population most likely to need the label. Confirmed by browser evidence: `flt-semantics-host` had 0 populated children even after click + Tab interaction this session; document-wide `aria-label` count = 1, `img[alt]` count = 0.
- `SkillsSection` receives a `skills` param (with proficiency ratings from `portfolio_service.dart`) but renders `const SkillsGrid()`, which ignores it entirely in favor of its own hardcoded icon list — dead data path.
- `AppRouter`/go_router is maintained but unused per this repo's own CLAUDE.md — unrelated to this critique's scope but worth a cleanup pass.
- No console errors in either desktop or mobile session — only expected Flutter service-worker bootstrap debug lines.

## Questions to Consider

1. If the nav order has drifted this far from the actual scroll order — and the navbar physically overlaps content on the very first link a visitor might click — was this build tested end-to-end by a real visitor before shipping?
2. The Projects section's clearest signal ("here's what I actually built") is undercut by generic trophy/timer/checkmark icons with no connection to the work. If most projects are confidential/internal and can't show a screenshot, is a decorative icon adding credibility, or just filling space?
3. The page spends more pixels and repetitions on Azure Fundamentals-tier certifications than on describing what the flagship AlphaBOLD role actually shipped — is that the impression you want a hiring manager to walk away with?
