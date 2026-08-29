---
name: Sultan Khan — Portfolio
description: A neon-terminal dark portfolio for a Senior AI Solutions Developer, where glow signals interaction and the background never goes still.
colors:
  neon-magenta: "#FF2E93"
  soft-pink: "#FF6FB8"
  neon-cyan: "#22D9FF"
  near-black-violet: "#07060B"
  dark-violet-grey: "#14111C"
  medium-violet-grey: "#201B2C"
  text-white: "#FFFFFF"
  lavender-grey: "#C2B8D6"
  muted-lavender: "#8A81A0"
typography:
  display:
    fontFamily: "Inter, -apple-system, sans-serif"
    fontSize: "64px"
    fontWeight: 900
    lineHeight: 1.1
    letterSpacing: "-2px"
  headline:
    fontFamily: "Inter, -apple-system, sans-serif"
    fontSize: "32px"
    fontWeight: 700
    lineHeight: 1.2
    letterSpacing: "-0.5px"
  title:
    fontFamily: "Inter, -apple-system, sans-serif"
    fontSize: "22px"
    fontWeight: 600
    lineHeight: 1.3
    letterSpacing: "normal"
  body:
    fontFamily: "Inter, -apple-system, sans-serif"
    fontSize: "16px"
    fontWeight: 400
    lineHeight: 1.6
    letterSpacing: "normal"
  label:
    fontFamily: "Inter, -apple-system, sans-serif"
    fontSize: "12px"
    fontWeight: 600
    lineHeight: 1.3
    letterSpacing: "0.4px"
rounded:
  xs: "3px"
  sm: "12px"
  md: "16px"
  lg: "20px"
spacing:
  xs: "8px"
  sm: "12px"
  md: "16px"
  lg: "24px"
  xl: "40px"
  xxl: "80px"
components:
  button-primary:
    backgroundColor: "{colors.neon-magenta}"
    textColor: "#FFFFFF"
    rounded: "{rounded.sm}"
    padding: "16px 32px"
    typography: "{typography.body}"
  button-outline:
    backgroundColor: "transparent"
    textColor: "{colors.neon-magenta}"
    rounded: "{rounded.sm}"
    padding: "16px 32px"
    typography: "{typography.body}"
  card-surface:
    backgroundColor: "{colors.dark-violet-grey}"
    textColor: "{colors.text-white}"
    rounded: "{rounded.sm}"
    padding: "20px"
  chip-tag:
    backgroundColor: "{colors.neon-magenta}"
    textColor: "{colors.neon-magenta}"
    rounded: "{rounded.lg}"
    padding: "10px 16px"
    typography: "{typography.body}"
---

# Design System: Sultan Khan — Portfolio

## Overview

**Creative North Star: "The Neon Terminal"**

This is a dev-tool's confidence rendered as a portfolio, not a design agency's restraint. The palette is a two-color signal (Neon Magenta and Neon Cyan) burning against a near-black violet void — the same instinct as a terminal prompt or a status LED, not a corporate brand system. Nothing sits inert: a three-layer animated background (drifting gradient, floating dust, crossing smoke) keeps the whole page breathing even when the visitor isn't touching anything, and every interactive surface answers a hover or tap with a brighter, wider glow rather than a static color change.

The system rejects the generic "clean minimalist portfolio" reference entirely — flat white cards, muted pastels, and gentle drop-shadows have no place here. Depth is never gray; it's colored light. Density stays generous (wide padding, roomy type scale) so the neon reads as confident, not cluttered.

**Key Characteristics:**
- Two-color neon signal (magenta + cyan) on near-black violet, never neutral gray or black surfaces
- Glow is the only depth cue — no plain black box-shadows anywhere in the system
- Persistent animated ambient background (gradient wash, particles, smoke) — always running, respects reduced-motion
- Scroll-triggered reveal cascade on every section; idle float/rotate/pulse loops on hero and skill icons
- Generous whitespace and a bold, confident type scale (Inter, weights 300–900)

## Colors

Two-color neon signal on a near-black violet ground; every other hue in the system is a tint or lerp of this pair.

### Primary
- **Neon Magenta** (`#FF2E93`): the system's dominant signal — headings, active nav state, primary buttons, borders and glows on virtually every interactive surface. Read this as "the accent," used far more liberally than a typical 10%-rule accent because the whole brand voice is built on it.

### Secondary
- **Neon Cyan** (`#22D9FF`): magenta's constant counterpart, never used alone — always paired in a gradient (photo rings, section-heading bar, experience rail, progress rail) or as the opposite pole of a dual-glow. Reads as "current/electricity" against magenta's "signal/energy."

### Tertiary
- **Soft Pink** (`#FF6FB8`): a third, lighter stop reserved for the deterministic tech-color hash (project cards) and Material's `colorScheme.secondary` — a controlled-rarity accent, not a general-purpose color.

### Neutral
- **Near-Black Violet** (`#07060B`): page background — never pure black; carries a faint violet cast that keeps the neon from looking harsh.
- **Dark Violet-Grey** (`#14111C`): the standard bordered-surface color for cards (About bio, education cards, now-cards, contact rows, certification cards).
- **Medium Violet-Grey** (`#201B2C`): the theme's `Card` default and floating-skill-icon tile background — one step lighter than surface, for content that should read as slightly raised.
- **White** (`#FFFFFF`): primary text and the dominant headline color when not tinted magenta.
- **Lavender-Grey** (`#C2B8D6`): secondary body text — never pure gray, always carries the violet family through.
- **Muted Lavender** (`#8A81A0`): the quietest text tier (captions, `bodySmall` default).

### Named Rules
**The No Neutral Rule.** No surface, border, or text color in this system is true gray or true black. Backgrounds and text neutrals are all violet-tinted; shadows and glows are always magenta or cyan, never `Colors.black` alone (the one exception — the mobile nav menu's drop shadow and the scrim behind it — stays black specifically because it needs to read as "recede," not "signal").

**The Triad Rule.** Any place the system needs to color something dynamically (per-technology chips, generative project fingerprints) draws from the same three stops — Magenta → Cyan → Soft Pink → Magenta — via deterministic hash, never an arbitrary or expanding palette.

## Typography

**Display/Body Font:** Inter (with `-apple-system, sans-serif` fallback) — one typeface for the whole system; hierarchy comes from size, weight, and letter-spacing, not a font pairing.

**Character:** Confident and heavy at the top of the scale (weights 700–900, tight negative letter-spacing on display/headline), relaxing to a lighter, wider-tracked touch at the label tier — the same instinct as a terminal's bold prompt versus its dim status text.

### Hierarchy
- **Display** (900, 64px, 1.1 line-height, -2px tracking): reserved for the largest single moment on the page (not currently used at full display scale — headline carries the hero name; keep display in reserve for a future full-bleed statement).
- **Headline** (700, 32px, 1.2, -0.5px): hero name, navbar wordmark scale-down, section-level emphasis.
- **Title** (600, 22px, 1.3): section sub-heads ("Education", "Let's work together!", experience role titles, project names).
- **Body** (400, 16px, 1.6, up to ~75ch): bio paragraphs, descriptions, contact copy.
- **Label** (600, 12px, 1.3, 0.4px tracking, often uppercase-styled content like "READING RIGHT NOW"): eyebrow labels, captions, the smallest UI text.

### Named Rules
**The Weight-Carries-Hierarchy Rule.** Don't introduce a second typeface for emphasis — every hierarchy shift in this system is size + weight + tracking on Inter alone (e.g. the hero title sits at `titleLarge` weight 300 specifically to read as quieter than the bold `headlineLarge` name directly above it).

## Layout

Single-page, vertically stacked sections (Hero → About → Skills → Experience → Certifications → Projects → Contact → Socials), each its own full-bleed `Container` with `EdgeInsets.symmetric(horizontal: 40, vertical: 80)` as the default section rhythm (`spacing.xl` sides, `spacing.xxl` top/bottom). A single mobile breakpoint at **800px** governs Hero, About, and Contact's stacked-vs-side-by-side layout; the Navbar uses its own **1100px** breakpoint (raised from 800px once the nav grew to 7 items — the desktop item row has no flex/scroll, so it needs more room before switching from the hamburger menu); a separate **700px** breakpoint governs Projects/Certifications' 1-vs-2-column wrap; the Skills grid steps its own column count at 600/900/1200px. `LayoutBuilder`-driven responsive composition (not fixed breakpoint widgets) is the norm throughout — width-aware rather than device-aware.

A persistent `ScrollProgressRail` (3px gradient bar, top edge, magenta→cyan) threads every section into one continuous journey, and the floating `ModernNavbar` docks from top-of-page to a bottom-pinned pill once scrolled, animating the transition rather than snapping.

## Elevation & Depth

**The Signal, Not Shadow Rule.** This system carries no neutral elevation model — there is no "flat vs. lifted" surface language independent of color. Depth is glow: every `BoxShadow` in the codebase is tinted magenta or cyan (frequently both, as a dual-color glow on opposite offsets), and its presence or intensity is a state signal — "this is alive," "this is hovered," "this is being read" — not a static resting elevation. A component with no glow reads as inert; a component gains glow the moment it becomes interactive-relevant. Never flatten a glow to a plain black shadow, and never add elevation as decoration on something that isn't actually signaling state.

### Shadow Vocabulary
- **Resting glow** (`0 0 10px rgba(FF2E93, 0.2)`, spread 2): default state on floating skill icons and similar always-present accents.
- **Hover/active glow** (`0 0 20px rgba(FF2E93, 0.4)` + a second `0 0 30px rgba(FF2E93, 0.3)` spread 8 layer): the amplified response to hover — always at least one blur/spread step brighter and wider than resting.
- **Dual-pole glow** (two shadows, same blur/spread, offset ±6px horizontally, one magenta one cyan): the hero photo ring and portrait treatment — reads as one object lit from two colored sources at once.
- **Chrome shadow** (`Colors.black` alpha 0.4, blur 24, offset (0,12)): the one deliberate exception — mobile nav menu panel and its scrim, which need to recede/separate rather than signal.

### Named Rules
**The Amplify-On-Interaction Rule.** Hover/active states never introduce a new visual language — they turn the same glow up (wider blur, more spread, sometimes a second shadow layer), never swap in a different effect.

## Shapes

Rounded rectangles at four scale steps — `xs` (3px, the section-heading accent bar only), `sm` (12px, the most common: buttons, chips, bordered content cards, nav items), `md` (16px, one step up: icon tiles, the theme's default Card, certification cards), `lg` (20px, the largest: glass panels, portraits, project cards). Avatars, badges, and icon buttons that aren't rectangular go to a true circle (`BoxShape.circle`), never a very-high radius approximation. Borders are thin (1–2.5px) and always a low-alpha tint of magenta (0.2–0.3 at rest, brightening on interaction) rather than a neutral gray hairline.

## Components

### Buttons
- **Shape:** 12px radius, no elevation (flat fill, glow comes from the surrounding context, not the button itself).
- **Primary:** magenta fill, white text, `16px 32px` padding, `bodyLarge`-weight-600 label.
- **Outline/Ghost:** transparent fill, 2px magenta border, magenta text — used for secondary actions ("Live" vs. primary "Code" on project cards).

### Chips (tags)
- **Style:** magenta fill at 10% alpha, magenta text, pill-shaped (20px radius) for hero signal tags; smaller 12px-radius chip with an inline tech icon for project tech tags.
- **State:** no distinct selected/unselected variant — chips in this system are always informational, never toggleable.

### Cards / Containers
- **Corner Style:** 12px for the common bordered-surface card (About bio, education, now-cards, contact rows); 16px for icon tiles and certification cards; 20px for the largest surfaces (project cards, portraits, glass panels).
- **Background:** Dark Violet-Grey (`#14111C`) is the default card surface; the theme's Material `Card` (used by Experience and Project cards) uses Medium Violet-Grey (`#201B2C`) instead — one step lighter, for content that already carries its own internal color (fingerprint art, timeline badge).
- **Shadow Strategy:** see Elevation & Depth — resting cards are borderline-flat (thin low-alpha border only), glow appears on hover or as a permanent low-alpha "this card matters" signal (certification cards carry a faint permanent glow; generic content cards don't).
- **Border:** 1px, magenta at 0.2–0.3 alpha, universal across every bordered card variant.

### Inputs / Fields
- **Style:** filled with Dark Violet-Grey, no border at rest, 12px radius.
- **Focus:** 2px solid magenta border replaces the invisible resting border — no glow on inputs specifically (the one component-state exception to the glow-on-interaction rule, since form fields aren't implemented as live UI in the current build — inherited from `AppTheme.inputDecorationTheme`, not yet exercised by a real form).

### Navigation
- **Style:** a floating pill (not a full-width bar) — transparent at the top of the page, glassmorphic (20px backdrop blur + magenta-tinted gradient fill + magenta border/glow) once scrolled. Docks from a top position to a bottom-pinned position via an animated slide+fade, not a snap. Nav items get a subtle magenta background+border wash only when the page is in its scrolled (glass) state; at the top they're transparent text-only.
- **Mobile:** hamburger toggle replaces the item row below 1100px; opens a glass dropdown panel (same 20px-blur treatment) with a dark scrim behind it, anchored above or below the pill depending on dock position.

### Signature Component: Floating Skill Icon
The skills grid's defining motif — each icon idles in a perpetual sine-wave float (±15px) with subtle rotation (±0.05rad) and scale breathing (0.95–1.05), staggered per icon so the grid never moves as one rigid block. On hover, the float freezes, the icon lifts to 1.1x scale, and its glow intensifies from a resting single-layer glow to a two-layer amplified glow with a visible border. This "always slightly alive, more alive on touch" behavior is the clearest single expression of the Neon Terminal identity and should be the reference point when adding new interactive iconography.

## Do's and Don'ts

### Do:
- **Do** keep the animated background (gradient wash, particles, smoke) running everywhere — it's core identity, not optional chrome — while always respecting `MediaQuery.disableAnimations` / reduced-motion.
- **Do** tint every shadow and glow magenta or cyan (or both, as a dual-pole glow); depth is color, never gray.
- **Do** amplify existing glow on hover/focus rather than introducing a new effect.
- **Do** stagger multi-item reveals and idle loops (float, pulse, cascade) so groups never move as one rigid block.
- **Do** derive any dynamically-colored element (chips, generative art) from the Magenta → Cyan → Soft-Pink triad via deterministic hash, so the same input always reads the same color.

### Don't:
- **Don't** introduce a light theme or a light-mode surface — `#07060B` is the only background this system has.
- **Don't** add a fourth brand hue outside the magenta/cyan/soft-pink triad.
- **Don't** flatten a glow into a plain neutral `box-shadow`/black elevation — that regresses the system's one depth language back to generic Material defaults.
- **Don't** use pure black or pure gray for text, borders, or surfaces — everything neutral in this system carries a violet tint.
- **Don't** add a second display typeface; hierarchy is Inter's own weight/size/tracking range, not a pairing.
