# Product

<!-- impeccable:product-schema 1 -->

## Platform

web

## Users

Three overlapping visitor types, all landing here to evaluate Sultan Khan as a hire or collaborator:
- Recruiters and hiring managers screening for senior AI/Flutter roles
- Freelance/consulting prospects evaluating him for contract engagements
- Professional network/personal-brand visitors (LinkedIn readers, peers, conference contacts)

Job for all three: quickly judge credibility and fit, then find a path to contact (email/LinkedIn/GitHub).

## Product Purpose

A single-page professional portfolio that showcases Sultan Khan's skills, experience, and projects, and converts a visit into a job lead, a contract lead, or a network connection. Success = visitor forms a credible impression and reaches out (email, LinkedIn, GitHub) or remembers him for a role/referral.

## Positioning

Senior AI Solutions Developer at the intersection of production Flutter engineering and applied agentic AI (Azure AI Foundry, MCP, LangChain, Claude Code workflows) — not a generalist full-stack profile. Six-time Microsoft certified with shipped, funded production systems (BLE/IoT mobile for a $10M-seed startup, enterprise HR/CRM AI tooling, healthcare-compliance automation) as evidence, not claims.

## Operating Context

- Content is fully hardcoded/mock data in `lib/services/portfolio_service.dart` (no backend, no CMS) — copy edits mean editing Dart source directly.
- Single `LandingPage` with vertically stacked sections (Hero → About → Skills → Experience → Projects → Contact/Socials), navigated via `ModernNavbar` scroll-to-section.
- Deployed as a Flutter web build; this is the primary and only shipped target (mobile/desktop Flutter targets are not the deployment story per README, despite Flutter's cross-platform capability).

## Capabilities and Constraints

- Contact paths: email (sultan512@gmail.com), LinkedIn, GitHub, phone — no working contact form/backend beyond what's in `contact_section.dart`.
- "Now playing" / "reading now" widgets (Spotify embed, reading card) are live personal-activity touches, not static resume content — keep these functioning and current, not decorative.
- No pricing, licensing, or deployment claims apply (personal site, not a commercial product).

## Brand Commitments

- Name: Sultan Khan. Title: Senior AI Solutions Developer.
- Dark theme with vibrant orange (#FF6B35) accent, Inter typeface (Google Fonts) — established in `AppTheme`; see DESIGN.md once documented for the full system.
- Voice in existing copy (`aboutBio`, `profile`) is first-person, concrete, evidence-led (named clients, funding amounts, specific tech) rather than generic self-praise — preserve this register in future copy.

## Evidence on Hand

- Real, resume-sourced facts only, in `portfolio_service.dart`: personal info, education, 6 employers' work history, 15 skills with proficiency levels, 6 named projects with tech/features, 6 Microsoft certifications.
- **No testimonials, client quotes, or client logos exist.** Do not fabricate them — this was explicitly confirmed. Any future "social proof" section must use only real, sourced material or be omitted.
- Profile photo at `assets/sultan_angle.jpg`.

## Product Principles

1. Every claim on the page must trace to real resume/project data — evidence over assertion, no invented metrics or quotes.
2. Serve all three visitor types (recruiter, client, network) with one coherent narrative rather than forking the page per audience.
3. Keep the AI-and-Flutter positioning sharp and specific; resist diluting into a generic "full-stack developer" framing.
4. Contact conversion is the functional goal of every section — content should build toward "reach out," not just inform.
5. Live/personal touches (now-playing, reading-now) signal an active, current person, not a static resume — keep them real and maintained.

## Accessibility & Inclusion

No product-specific requirement established beyond general web accessibility best practice.
