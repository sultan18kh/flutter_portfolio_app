import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/portfolio_cubit.dart';
import '../blocs/navbar_bloc/navbar_cubit.dart';
import '../widgets/animated_background.dart';
import '../widgets/modern_navbar.dart';
import '../widgets/sections/hero_section.dart';
import '../widgets/sections/about_section.dart';
import '../widgets/sections/experience_section.dart';
import '../widgets/sections/certifications_section.dart';
import '../widgets/sections/projects_section.dart';
import '../widgets/sections/skills_section.dart';
import '../widgets/sections/contact_section.dart';
import '../widgets/sections/socials_section.dart';
import '../widgets/reveal_on_scroll.dart';
import '../widgets/hero_about_morph.dart';
import '../widgets/scroll_progress_rail.dart';
import '../utils/app_theme.dart';
import '../utils/morph_keys.dart';
import '../utils/photo_morph_progress.dart';
import '../utils/section_keys.dart';

/// The debounce/ceiling arithmetic behind the section-snap scroll hold,
/// pulled out as a pure function so it can be exercised without a real
/// Timer clock. Debounces the hold's release (each event pushes it out by
/// [settle]) but never past [deadline], so a momentum tail that's still
/// arriving keeps the hold alive while a genuinely continuous scroll still
/// gets released eventually.
Duration scrollHoldReleaseDelay({
  required DateTime deadline,
  required Duration settle,
  required DateTime now,
}) {
  final remaining = deadline.difference(now);
  if (remaining <= Duration.zero) return Duration.zero;
  return remaining < settle ? remaining : settle;
}

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  late ScrollController _scrollController;
  final PhotoMorphProgress _morphProgress = PhotoMorphProgress();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScrollForMorph);

    // Load portfolio data after the widget is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<PortfolioCubit>().loadPortfolio();
      }
    });
  }

  void _onScrollForMorph() => _morphProgress.recompute(_scrollController);

  /// Every section's resting (flush-at-top) offset, clamped to the
  /// scrollable's real extent — the same computation `NavbarCubit` uses for
  /// nav-click jumps, so a click and a scroll-snap always agree on where a
  /// section "starts."
  List<double> _sectionOffsets(ScrollPosition position) {
    final offsets = <double>[];
    for (final entry in SectionKeys.keys.entries) {
      final renderObject = entry.value.currentContext?.findRenderObject();
      if (renderObject == null) continue;
      final viewport = RenderAbstractViewport.of(renderObject);
      final revealOffset = viewport.getOffsetToReveal(renderObject, 0.0).offset;
      offsets.add(NavbarCubit.restingOffsetFor(entry.key, revealOffset)
          .clamp(position.minScrollExtent, position.maxScrollExtent));
    }
    offsets.sort();
    return offsets;
  }

  // No magnetic pull in either direction — a visitor has to be able to
  // rest anywhere inside a tall section (reading through Portfolio's cards,
  // say) without being pulled toward a boundary just because they paused.
  // The only rule: scrolling down can't skip past a section's start.
  //
  // Desktop/web trackpad and mouse-wheel scrolling arrives as discrete
  // PointerScrollEvents that Scrollable applies via a raw, un-clamped
  // `forcePixels` call (ScrollPositionWithSingleContext.pointerScroll) —
  // it never goes through ScrollPhysics.applyBoundaryConditions, so a
  // physics-level clamp can't stop it landing past a boundary, and
  // correcting afterwards (a post-hoc jumpTo in response to the resulting
  // notification) always lets that one frame's overshoot paint first,
  // which is the "leaks a little before snapping back" visible in
  // practice. The only way to make it land exactly on the boundary is to
  // intercept the event itself, before Scrollable's own handler runs, and
  // substitute a precise jumpTo for the raw delta.
  double? _holdBoundary;
  Timer? _lockRelease;
  DateTime? _holdDeadline;

  // Flutter web has no signal for "the visitor's fingers actually lifted
  // off the trackpad" — a wheel/trackpad scroll arrives as plain
  // PointerScrollEvents with no drag-start/drag-end of its own. A release
  // timer fixed at the moment of crossing and never touched again is blind
  // to whether momentum is still arriving: trackpad decay routinely outlasts
  // it, so the hold lets go mid-tail and the next (still real, still
  // shrinking) delta gets treated as ordinary scrolling and nudges the view
  // past the boundary before it finally reaches zero — the "pauses, then
  // leaks a little" seen in practice. Debounce the release instead: every
  // event that arrives while holding pushes it out by `_holdSettle`, so it
  // only fires once the deltas have actually stopped. `_holdMaxWindow` caps
  // how far that can be pushed, so a genuinely continuous, deliberate
  // scroll (wheel notches closer together than `_holdSettle`) still gets
  // through eventually instead of being trapped at the boundary forever.
  static const _holdSettle = Duration(milliseconds: 120);
  static const _holdMaxWindow = Duration(milliseconds: 900);

  void _armReleaseTimer() {
    _lockRelease?.cancel();
    _lockRelease = Timer(
      scrollHoldReleaseDelay(deadline: _holdDeadline!, settle: _holdSettle, now: DateTime.now()),
      () => _holdBoundary = null,
    );
  }

  double? _nextCrossing(ScrollPosition position, double previous, double current) {
    double? crossed;
    for (final target in _sectionOffsets(position)) {
      if (target > previous + 0.5 && target <= current) {
        if (crossed == null || target < crossed) crossed = target;
      }
    }
    return crossed;
  }

  // PointerSignalResolver always favors whichever registered candidate is
  // deepest in the widget tree, so a Listener wrapping the scroll content
  // (a descendant of Scrollable's own internal one) gets first refusal on
  // every wheel/trackpad event — claim it only when this event would cross
  // a boundary, otherwise leave it alone so Scrollable scrolls normally.
  void _onPointerSignal(PointerSignalEvent event) {
    if (event is! PointerScrollEvent) return;
    if (!_scrollController.hasClients) return;

    final delta = event.scrollDelta.dy;
    if (delta <= 0) return; // only downward scrolling is constrained

    final position = _scrollController.position;
    final current = position.pixels;

    if (_holdBoundary != null) {
      final boundary = _holdBoundary!;
      GestureBinding.instance.pointerSignalResolver.register(event, (_) {
        _scrollController.jumpTo(boundary);
        _armReleaseTimer();
      });
      return;
    }

    final rawTarget =
        (current + delta).clamp(position.minScrollExtent, position.maxScrollExtent);
    final crossed = _nextCrossing(position, current, rawTarget);
    if (crossed == null) return;

    GestureBinding.instance.pointerSignalResolver.register(event, (_) {
      _scrollController.jumpTo(crossed);
      _holdBoundary = crossed;
      _holdDeadline = DateTime.now().add(_holdMaxWindow);
      _armReleaseTimer();
    });
  }

  @override
  void dispose() {
    _lockRelease?.cancel();
    _scrollController.removeListener(_onScrollForMorph);
    _scrollController.dispose();
    _morphProgress.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBackground(
        scrollController: _scrollController,
        child: BlocBuilder<PortfolioCubit, PortfolioState>(
          builder: (context, state) {
            // Safety check to prevent rendering when widget is disposed
            if (!mounted) {
              return const SizedBox.shrink();
            }
            if (state is PortfolioLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppTheme.primaryColor,
                ),
              );
            }

            if (state is PortfolioError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error: ${state.message}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () =>
                          context.read<PortfolioCubit>().loadPortfolio(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (state is PortfolioLoaded) {
              return RevealScrollScope(
                controller: _scrollController,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Stack(
                    key: MorphKeys.stackOrigin,
                    clipBehavior: Clip.hardEdge,
                    children: [
                      // Main content
                      SingleChildScrollView(
                        controller: _scrollController,
                        child: Listener(
                          onPointerSignal: _onPointerSignal,
                          behavior: HitTestBehavior.opaque,
                          child: Column(
                            children: [
                              // Add top padding to account for floating navbar
                              const SizedBox(height: AppTheme.navbarClearance),

                              // Hero Section
                              HeroSection(
                                key: SectionKeys.keys['home'],
                                personalInfo: state.personalInfo,
                                morphProgress: _morphProgress,
                                scrollController: _scrollController,
                              ),

                              // About Section
                              RevealOnScroll(
                                child: AboutSection(
                                  key: SectionKeys.keys['about'],
                                  personalInfo: state.personalInfo,
                                  education: state.education,
                                  morphProgress: _morphProgress,
                                ),
                              ),

                              // Skills Section
                              RevealOnScroll(
                                child: SkillsSection(
                                  key: SectionKeys.keys['skills'],
                                  skills: state.skills,
                                ),
                              ),

                              // Experience Section
                              ExperienceSection(
                                key: SectionKeys.keys['experience'],
                                experience: state.experience,
                              ),

                              // Certifications Section
                              CertificationsSection(
                                key: SectionKeys.keys['certifications'],
                                certifications: state.certifications,
                              ),

                              // Projects Section
                              ProjectsSection(
                                key: SectionKeys.keys['projects'],
                                projects: state.projects,
                              ),

                              // Contact Section — the page's closing beat, so
                              // socials render right beneath it instead of
                              // trailing off as an unreachable, disconnected
                              // section of their own.
                              Column(
                                key: SectionKeys.keys['contact'],
                                children: [
                                  ContactSection(
                                    personalInfo: state.personalInfo,
                                  ),
                                  const SocialsSection(),
                                ],
                              ),

                              // Reserve space so content never sits behind
                              // the floating bottom navbar at max scroll.
                              const SizedBox(height: 160),
                            ],
                          ),
                        ),
                      ),

                      // Traveling avatar for the Hero→About photo morph —
                      // above the scrolling content, below the navbar.
                      HeroAboutMorph(
                        progress: _morphProgress,
                        personalInfo: state.personalInfo,
                      ),

                      // Floating Navigation Bar
                      ModernNavbar(scrollController: _scrollController),

                      // Whole-page scroll progress — a fixed rail at the
                      // very top edge, independent of and above everything
                      // else, so it never competes with a section's own
                      // moment.
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        height: 3,
                        child: ScrollProgressRail(
                          controller: _scrollController,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return const Center(
              child: Text('No data available'),
            );
          },
        ),
      ),
    );
  }
}
