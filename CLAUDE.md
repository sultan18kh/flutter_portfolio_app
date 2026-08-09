# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build & Development Commands

```bash
# Install dependencies
flutter pub get

# Run the app (web is the primary target)
flutter run -d chrome

# Build for web deployment
flutter build web

# Code generation (for JSON serialization)
dart run build_runner build
dart run build_runner watch  # watch mode
dart run build_runner build --delete-conflicting-outputs  # if generation conflicts

# Linting
flutter analyze

# Run tests
flutter test
```

## Architecture Overview

This is a single-page Flutter web portfolio application using a dark theme with orange accents.

### State Management Pattern
- Uses **Cubit** (not full Bloc) from `flutter_bloc` for state management
- Two cubits:
  - `PortfolioCubit` (`lib/blocs/portfolio_cubit.dart`): Manages portfolio data loading with states: Initial → Loading → Loaded/Error
  - `NavbarCubit` (`lib/blocs/navbar_bloc/navbar_cubit.dart`): Manages navbar scroll state (via a `ScrollController` listener) and drives `scrollToSection` navigation using hardcoded pixel offsets per section

### Data Flow
1. `LandingPage` triggers `PortfolioCubit.loadPortfolio()` in `initState`
2. `PortfolioService` provides mock data (all data is hardcoded, no backend)
3. `PortfolioLoaded` state contains all models: PersonalInfo, Education, Experience, Skill, Project, Certification
4. Section widgets receive data as constructor parameters

### Page Structure
Single `LandingPage` with vertically stacked sections:
- `HeroSection` → `AboutSection` → `SkillsSection` → `ExperienceSection` → `ProjectsSection` → `ContactSection`
- `ModernNavbar` floats above content and handles scroll-to-section navigation
- `AnimatedBackground` wraps the entire page
- `SkillsSection` renders `SkillsGrid`, a responsive `Wrap` of `FloatingSkillIcon` widgets (per-icon float/rotate/scale animation, hover state) driven by a static skill list in `lib/widgets/skills_grid.dart` pointing at SVGs in `assets/skills/`. Add a new skill by dropping an SVG in `assets/skills/` and adding an entry to `SkillsGrid.skills`.

### Models
All models in `lib/models/` use:
- `@JsonSerializable()` annotation (requires `build_runner` for `.g.dart` files)
- `Equatable` for value equality
- Immutable `const` constructors

### Theme
`AppTheme` in `lib/utils/app_theme.dart` defines the color scheme:
- Primary: `#FF6B35` (vibrant orange)
- Background: `#0A0A0A` (deep black)
- Uses Google Fonts (Inter)

### Key Patterns
- Cubits check `isClosed` before emitting to prevent errors after disposal
- `LandingPage` uses `mounted` checks for safe async operations
- `AppRouter` (`lib/utils/app_router.dart`) defines a single `/` route via Go Router, but `main.dart` does not currently wire it into `MaterialApp` (it uses `home: const LandingPage()` directly) — the router is effectively dead code until connected
