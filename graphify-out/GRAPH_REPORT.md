# Graph Report - portfolio_flutter  (2026-08-29)

## Corpus Check
- 87 files · ~434,058 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 718 nodes · 908 edges · 69 communities (53 shown, 16 thin omitted)
- Extraction: 99% EXTRACTED · 1% INFERRED · 0% AMBIGUOUS · INFERRED: 9 edges (avg confidence: 0.78)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `e93715a7`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- [[_COMMUNITY_Windows Win32 Runner|Windows Win32 Runner]]
- [[_COMMUNITY_iOSmacOS App Delegate & Plugins|iOS/macOS App Delegate & Plugins]]
- [[_COMMUNITY_Navbar Cubit State|Navbar Cubit State]]
- [[_COMMUNITY_Floating Skill Icon Animation|Floating Skill Icon Animation]]
- [[_COMMUNITY_Animated Background Painter|Animated Background Painter]]
- [[_COMMUNITY_Linux GTK Runner|Linux GTK Runner]]
- [[_COMMUNITY_Landing Page Shell|Landing Page Shell]]
- [[_COMMUNITY_Portfolio Cubit States|Portfolio Cubit States]]
- [[_COMMUNITY_App Theme Colors|App Theme Colors]]
- [[_COMMUNITY_About & Hero Sections|About & Hero Sections]]
- [[_COMMUNITY_PersonalInfo Model|PersonalInfo Model]]
- [[_COMMUNITY_Windows Runner Utils|Windows Runner Utils]]
- [[_COMMUNITY_Project Model|Project Model]]
- [[_COMMUNITY_Web App Manifest|Web App Manifest]]
- [[_COMMUNITY_Windows FlutterWindow|Windows FlutterWindow]]
- [[_COMMUNITY_Portfolio Service|Portfolio Service]]
- [[_COMMUNITY_Education Model|Education Model]]
- [[_COMMUNITY_Contact Section|Contact Section]]
- [[_COMMUNITY_Data Model Base (EquatableJSON)|Data Model Base (Equatable/JSON)]]
- [[_COMMUNITY_Skills Grid Widget|Skills Grid Widget]]
- [[_COMMUNITY_Certification Model|Certification Model]]
- [[_COMMUNITY_Experience Model|Experience Model]]
- [[_COMMUNITY_Projects Section|Projects Section]]
- [[_COMMUNITY_Community 23|Community 23]]
- [[_COMMUNITY_Experience Section|Experience Section]]
- [[_COMMUNITY_Skill Model|Skill Model]]
- [[_COMMUNITY_Skills Section|Skills Section]]
- [[_COMMUNITY_Section Widgets Base|Section Widgets Base]]
- [[_COMMUNITY_App Entry Point|App Entry Point]]
- [[_COMMUNITY_Flutter LLDB Build Helper|Flutter LLDB Build Helper]]
- [[_COMMUNITY_Community 30|Community 30]]
- [[_COMMUNITY_Cross-Platform App Identity|Cross-Platform App Identity]]
- [[_COMMUNITY_Flutter Engine Plugin Registrant|Flutter Engine Plugin Registrant]]
- [[_COMMUNITY_iOS Launch Screen & Web Title|iOS Launch Screen & Web Title]]
- [[_COMMUNITY_Windows FlutterWindow Header|Windows FlutterWindow Header]]
- [[_COMMUNITY_Windows CMake Build Chain|Windows CMake Build Chain]]
- [[_COMMUNITY_Android MainActivity|Android MainActivity]]
- [[_COMMUNITY_iOS Generated Plugin Registrant|iOS Generated Plugin Registrant]]
- [[_COMMUNITY_README Dependency Drift|README Dependency Drift]]
- [[_COMMUNITY_Lint Config Dependency|Lint Config Dependency]]
- [[_COMMUNITY_macOS Ephemeral Env Script|macOS Ephemeral Env Script]]
- [[_COMMUNITY_Linux CMake Build Chain|Linux CMake Build Chain]]
- [[_COMMUNITY_iOS Ephemeral Env Script|iOS Ephemeral Env Script]]
- [[_COMMUNITY_DevTools Options Config|DevTools Options Config]]
- [[_COMMUNITY_README Data Models Section|README Data Models Section]]
- [[_COMMUNITY_README PortfolioService Section|README PortfolioService Section]]
- [[_COMMUNITY_Community 55|Community 55]]
- [[_COMMUNITY_Community 56|Community 56]]
- [[_COMMUNITY_Community 58|Community 58]]
- [[_COMMUNITY_Community 59|Community 59]]
- [[_COMMUNITY_Community 60|Community 60]]
- [[_COMMUNITY_Community 61|Community 61]]
- [[_COMMUNITY_Community 62|Community 62]]
- [[_COMMUNITY_Community 63|Community 63]]
- [[_COMMUNITY_Community 64|Community 64]]
- [[_COMMUNITY_Community 65|Community 65]]
- [[_COMMUNITY_Community 66|Community 66]]
- [[_COMMUNITY_Community 67|Community 67]]
- [[_COMMUNITY_Community 68|Community 68]]

## God Nodes (most connected - your core abstractions)
1. `Sultan Khan - Flutter Portfolio Application` - 15 edges
2. `NavbarCubit` - 12 edges
3. `PortfolioCubit` - 11 edges
4. `Deployment Guide — sultankhan.me on Cloudflare Pages` - 11 edges
5. `Create()` - 10 edges
6. `MessageHandler()` - 10 edges
7. `WndProc()` - 9 edges
8. `PortfolioState` - 7 edges
9. `HWND` - 7 edges
10. `WindowClassRegistrar` - 7 edges

## Surprising Connections (you probably didn't know these)
- `iOS Launch Screen Asset Customization` --conceptually_related_to--> `Sultan Khan Flutter Portfolio Application (README)`  [INFERRED]
  ios/Runner/Assets.xcassets/LaunchImage.imageset/README.md → README.md
- `wWinMain()` --calls--> `CreateAndAttachConsole()`  [INFERRED]
  windows/runner/main.cpp → windows/runner/utils.cpp
- `_buildMobileNavItem` --references--> `NavbarCubit`  [EXTRACTED]
  lib/widgets/modern_navbar.dart → lib/blocs/navbar_bloc/navbar_cubit.dart
- `_buildNavItem` --references--> `NavbarCubit`  [EXTRACTED]
  lib/widgets/modern_navbar.dart → lib/blocs/navbar_bloc/navbar_cubit.dart
- `_ModernNavbarViewState` --references--> `NavbarCubit`  [EXTRACTED]
  lib/widgets/modern_navbar.dart → lib/blocs/navbar_bloc/navbar_cubit.dart

## Import Cycles
- None detected.

## Hyperedges (group relationships)
- **Cross-Platform Flutter Engine Embedding Build Pattern** — linux_cmakelists_flutter_subdir, flutter_cmakelists_linux_assemble, windows_cmakelists_subdirs, flutter_cmakelists_windows_assemble, runner_cmakelists_executable [INFERRED 0.85]
- **Shared App Identity: portfolio_flutter / Sultan Khan Portfolio** — pubspec_project_name, linux_cmakelists_binary_name, windows_cmakelists_binary_name, web_index_title [INFERRED 0.85]
- **README Documentation vs Actual pubspec.yaml Dependency Version Drift** — readme_dependencies, readme_portfoliobloc, pubspec_dependencies, pubspec_dev_dependencies [INFERRED 0.85]

## Communities (69 total, 16 thin omitted)

### Community 0 - "Windows Win32 Runner"
Cohesion: 0.09
Nodes (34): RegisterPlugins(), PluginRegistry, Point, RECT, OnCreate(), Create(), Destroy(), EnableFullDpiSupportIfAvailable() (+26 more)

### Community 1 - "iOS/macOS App Delegate & Plugins"
Cohesion: 0.07
Nodes (23): Any, Cocoa, Flutter, RegisterGeneratedPlugins(), FlutterAppDelegate, FlutterMacOS, FlutterPluginRegistry, Foundation (+15 more)

### Community 2 - "Navbar Cubit State"
Cohesion: 0.06
Nodes (38): ../blocs/navbar_bloc/navbar_cubit.dart, ../blocs/navbar_bloc/navbar_state.dart, Cubit, morph_keys.dart, NavbarCubit, NavbarInitial, NavbarState, NavbarUpdated (+30 more)

### Community 3 - "Floating Skill Icon Animation"
Cohesion: 0.05
Nodes (38): AnimationController, Duration, InheritedWidget, Widget, animation, animationDuration, assetPath, build (+30 more)

### Community 4 - "Animated Background Painter"
Cohesion: 0.07
Nodes (28): CustomPainter, dart:math, _ProjectFingerprintPainter, angle, build, child, color, createState (+20 more)

### Community 5 - "Linux GTK Runner"
Cohesion: 0.11
Nodes (20): FlPluginRegistry, fl_register_plugins(), GApplication, gboolean, gchar, GObject, GtkApplication, main() (+12 more)

### Community 6 - "Landing Page Shell"
Cohesion: 0.07
Nodes (35): GlobalKey, build, _buildCompactExperienceRow, _buildExperienceCard, _buildSectionTitle, _buildTimelineBadge, _companyLogos, createState (+27 more)

### Community 7 - "Portfolio Cubit States"
Cohesion: 0.18
Nodes (10): ../../models/education.dart, PhotoMorphProgress?, build, _buildCoverBanner, _buildEducationCard, _buildPortrait, _buildSectionTitle, education (+2 more)

### Community 8 - "App Theme Colors"
Cohesion: 0.12
Nodes (16): package:google_fonts/google_fonts.dart, static const Color, static const double, accentColor, AppTheme, backgroundColor, cardColor, gradientEnd (+8 more)

### Community 9 - "About & Hero Sections"
Cohesion: 0.14
Nodes (15): ChangeNotifier, dart:ui, PersonalInfo, build, _buildMorphFade, _downloadCv, _emailContact, morphProgress (+7 more)

### Community 10 - "PersonalInfo Model"
Cohesion: 0.14
Nodes (13): aboutBio, email, fromJson, github, home, linkedin, name, phoneNumbers (+5 more)

### Community 11 - "Windows Runner Utils"
Cohesion: 0.23
Nodes (9): _In_, _In_opt_, wWinMain(), CreateAndAttachConsole(), GetCommandLineArguments(), Utf8FromUtf16(), vector, string (+1 more)

### Community 12 - "Project Model"
Cohesion: 0.18
Nodes (10): description, features, fromJson, githubUrl, imageUrl, liveUrl, name, props (+2 more)

### Community 13 - "Web App Manifest"
Cohesion: 0.18
Nodes (10): background_color, description, display, icons, name, orientation, prefer_related_applications, short_name (+2 more)

### Community 14 - "Windows FlutterWindow"
Cohesion: 0.25
Nodes (7): ../reveal_on_scroll.dart, _badgeAssetFor, build, _buildCertificationCard, _buildSectionTitle, certifications, CertificationsSection

### Community 15 - "Portfolio Service"
Cohesion: 0.05
Nodes (40): ../blocs/portfolio_cubit.dart, build, main, MyApp, initializeScrollListener, reset, restingOffsetFor, scrollToSection (+32 more)

### Community 16 - "Education Model"
Cohesion: 0.22
Nodes (8): degree, field, fromJson, institution, period, props, score, toJson

### Community 17 - "Contact Section"
Cohesion: 0.22
Nodes (8): ../../models/personal_info.dart, package:url_launcher/url_launcher.dart, build, _buildContactItem, _buildPortrait, _buildSectionTitle, _launchUrl, personalInfo

### Community 18 - "Data Model Base (Equatable/JSON)"
Cohesion: 0.43
Nodes (8): @JsonSerializable, Equatable, Certification, Education, Experience, PersonalInfo, Project, Skill

### Community 19 - "Skills Grid Widget"
Cohesion: 0.20
Nodes (9): floating_skill_icon.dart, ../models/skill.dart, static const List, build, _getCrossAxisCount, _getIconSize, proficiencies, _proficiencyScale (+1 more)

### Community 20 - "Certification Model"
Cohesion: 0.25
Nodes (7): date, description, fromJson, issuer, name, props, toJson

### Community 21 - "Experience Model"
Cohesion: 0.25
Nodes (7): company, fromJson, period, props, responsibilities, title, toJson

### Community 22 - "Projects Section"
Cohesion: 0.08
Nodes (24): Map, Project, build, _buildSectionTitle, _buildTechChip, _colorForTech, createState, didChangeDependencies (+16 more)

### Community 23 - "Community 23"
Cohesion: 0.25
Nodes (7): package:auto_size_text/auto_size_text.dart, package:flutter_svg/flutter_svg.dart, build, _buildSectionTitle, _buildSocialButton, _launchUrl, SocialsSection

### Community 24 - "Experience Section"
Cohesion: 0.29
Nodes (6): build, _buildSectionTitle, skills, SkillsSection, ../skills_grid.dart, ../../utils/app_theme.dart

### Community 25 - "Skill Model"
Cohesion: 0.29
Nodes (6): fromJson, name, proficiency, props, toJson, package:json_annotation/json_annotation.dart

### Community 26 - "Skills Section"
Cohesion: 0.10
Nodes (26): certifications, education, experience, loadPortfolio, message, personalInfo, PortfolioCubit, PortfolioError (+18 more)

### Community 27 - "Section Widgets Base"
Cohesion: 0.25
Nodes (8): AboutSection, ContactSection, HeroSection, ProjectsSection, StatelessWidget, HeroAboutMorph, ModernNavbar, SkillsGrid

### Community 28 - "App Entry Point"
Cohesion: 0.18
Nodes (10): Acceptance Criteria, Changes, Commits, Dependencies & assets (`pubspec.yaml`, `assets/skills/`), Docs & tooling (`CLAUDE.md`, `USAGE.md`, `graphify-out/`, `.gitignore`), feat: replace static skill cards with animated floating icon grid, Landing page (`lib/pages/landing_page.dart`), Skills UI (`lib/widgets/floating_skill_icon.dart`, `lib/widgets/skills_grid.dart`, `lib/widgets/sections/skills_section.dart`) (+2 more)

### Community 29 - "Flutter LLDB Build Helper"
Cohesion: 0.33
Nodes (5): handle_new_rx_page(), __lldb_init_module(), Intercept NOTIFY_DEBUGGER_ABOUT_RX_PAGES and touch the pages., SBDebugger, SBFrame

### Community 30 - "Community 30"
Cohesion: 0.15
Nodes (12): Acceptance Criteria, Certifications & Experience (`certifications_section.dart`, `experience_section.dart`, `floating_skill_icon.dart`), Changes, Commits, Content updates (`portfolio_service.dart`, `about_section.dart`), feat: neon theme, certifications/socials sections, and UI craft polish, Layout & perf fixes (`reveal_on_scroll.dart`, `projects_section.dart`, `floating_skill_icon.dart`, `hero_section.dart`), Nav routing & accessibility (`navbar_cubit.dart`, `section_keys.dart`, `modern_navbar.dart`) (+4 more)

### Community 35 - "Windows CMake Build Chain"
Cohesion: 1.00
Nodes (3): Windows flutter_assemble/flutter_wrapper Targets, Windows Runner Executable Target, Windows add_subdirectory(flutter, runner)

### Community 38 - "README Dependency Drift"
Cohesion: 0.06
Nodes (30): 🏗️ Architecture, 👨‍💻 Author, Build for Web, Code Generation, Colors, 📞 Contact, 🤝 Contributing, Core Dependencies (+22 more)

### Community 50 - "README Data Models Section"
Cohesion: 0.22
Nodes (8): Acceptance Criteria, <Area/Task 1> (`<file>`, `<file>`), <Area/Task 2> (`<file>`), Changes, Commits, Summary, Test plan, <type>: <short PR title>

### Community 55 - "Community 55"
Cohesion: 0.20
Nodes (8): Architecture Overview, Build & Development Commands, Data Flow, Key Patterns, Models, Page Structure, State Management Pattern, Theme

### Community 56 - "Community 56"
Cohesion: 0.29
Nodes (6): Build for web deployment, Other commands, Prerequisites, Run, Setup, Usage

### Community 60 - "Community 60"
Cohesion: 0.40
Nodes (4): package:flutter/material.dart, static final Map, keys, SectionKeys

### Community 62 - "Community 62"
Cohesion: 0.22
Nodes (8): DartProject, MessageHandler(), HWND, LPARAM, LRESULT, FlutterWindow(), UINT, WPARAM

### Community 64 - "Community 64"
Cohesion: 0.29
Nodes (6): List, copyWith, isScrolled, isVisible, props, package:equatable/equatable.dart

### Community 65 - "Community 65"
Cohesion: 0.33
Nodes (5): static final GlobalKey, aboutPhoto, heroPhoto, MorphKeys, stackOrigin

### Community 66 - "Community 66"
Cohesion: 0.12
Nodes (16): 3a. Create a Cloudflare API token, 3b. Add repo secrets, 3c. Workflow file, Build command (installs Flutter, then builds), Deployment Guide — sultankhan.me on Cloudflare Pages, Ongoing, Prerequisites, Required: commit `wrangler.jsonc` (+8 more)

### Community 67 - "Community 67"
Cohesion: 0.18
Nodes (10): Acceptance Criteria, Architecture (`portfolio_cubit.dart`, `navbar_cubit.dart`, `landing_page.dart`), Changes, Commits, Craft & accessibility polish, Deployment (`DEPLOYMENT.md`, GitHub issue #11), feat: neon rebrand, certs/socials sections, UI polish, and deployment setup, Summary (+2 more)

### Community 68 - "Community 68"
Cohesion: 0.22
Nodes (8): Design Health Score, Design Specificity Verdict, Minor Observations, Overall Impression, Persona Red Flags, Priority Issues, Questions to Consider, What's Working

## Knowledge Gaps
- **413 isolated node(s):** `personalInfo`, `education`, `morphProgress`, `build`, `_buildCoverBanner` (+408 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **16 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `NavbarCubit` connect `Navbar Cubit State` to `Landing Page Shell`, `Portfolio Service`?**
  _High betweenness centrality (0.010) - this node is a cross-community bridge._
- **Why does `PortfolioCubit` connect `Skills Section` to `Navbar Cubit State`, `Portfolio Service`?**
  _High betweenness centrality (0.009) - this node is a cross-community bridge._
- **Why does `animation` connect `Floating Skill Icon Animation` to `Navbar Cubit State`, `Animated Background Painter`?**
  _High betweenness centrality (0.004) - this node is a cross-community bridge._
- **What connects `personalInfo`, `education`, `morphProgress` to the rest of the system?**
  _414 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Windows Win32 Runner` be split into smaller, more focused modules?**
  _Cohesion score 0.08658536585365853 - nodes in this community are weakly interconnected._
- **Should `iOS/macOS App Delegate & Plugins` be split into smaller, more focused modules?**
  _Cohesion score 0.06951871657754011 - nodes in this community are weakly interconnected._
- **Should `Navbar Cubit State` be split into smaller, more focused modules?**
  _Cohesion score 0.05512820512820513 - nodes in this community are weakly interconnected._