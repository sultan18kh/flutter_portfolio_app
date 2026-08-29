import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../../models/personal_info.dart';
import '../../utils/app_theme.dart';
import '../../utils/morph_keys.dart';
import '../../utils/photo_morph_progress.dart';

class HeroSection extends StatefulWidget {
  final PersonalInfo personalInfo;
  final PhotoMorphProgress? morphProgress;

  // Short, factual signal tags — re-expressing claims already made in
  // personalInfo.profile (Flutter/Azure AI/agentic AI, six-time certified),
  // not new copy, just scannable instead of a paragraph.
  static const List<String> _signals = [
    'Flutter',
    'Python',
    'Azure AI',
    'Agentic AI Systems',
    '6× Microsoft Certified',
  ];

  // Matches ModernNavbar's own mobile breakpoint, so the two sections
  // switch layout at the same width.
  static const double _mobileBreakpoint = 800;

  const HeroSection({
    super.key,
    required this.personalInfo,
    this.morphProgress,
  });

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with SingleTickerProviderStateMixin {
  // The load-in focal moment: photo+halo settle into place first, then
  // name, title, and signal tags cascade in behind it. Runs once per
  // mount, never replays on rebuild or scroll.
  late final AnimationController _entrance;
  bool _entranceStarted = false;

  @override
  void initState() {
    super.initState();
    _entrance = AnimationController(
      duration: const Duration(milliseconds: 1100),
      vsync: this,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_entranceStarted) return;
    _entranceStarted = true;
    if (MediaQuery.of(context).disableAnimations) {
      _entrance.value = 1;
    } else {
      _entrance.forward();
    }
  }

  @override
  void dispose() {
    _entrance.dispose();
    super.dispose();
  }

  // Confident, non-bouncy arrival curve (matches the site's other entrance
  // motion) applied to a slice of the shared entrance timeline.
  Animation<double> _segment(double start, double end) {
    return CurvedAnimation(
      parent: _entrance,
      curve: Interval(start, end, curve: const Cubic(0.16, 1, 0.3, 1)),
    );
  }

  Widget _riseIn(double start, double end, Widget child, {double by = 16}) {
    final animation = _segment(start, end);
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) => Opacity(
        opacity: animation.value,
        child: Transform.translate(
          offset: Offset(0, by * (1 - animation.value)),
          child: child,
        ),
      ),
      child: child,
    );
  }

  Widget _scaleIn(double start, double end, Widget child) {
    final animation = _segment(start, end);
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) => Opacity(
        opacity: animation.value,
        child: Transform.scale(
          scale: 0.85 + 0.15 * animation.value,
          child: child,
        ),
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isMobile = screenSize.width < HeroSection._mobileBreakpoint;
    // Dynamic, not stepped: on mobile the constraint is width, not the
    // (usually generous) height, so size off width directly — sizing off
    // the shorter side there was starving the photo down to its minimum,
    // leaving a small, oddly centered block in a sea of vertical space.
    // Desktop/tablet keep scaling off the shortest side so short viewports
    // still shrink smoothly.
    final photoSize = isMobile
        ? (screenSize.width * 0.42).clamp(150.0, 220.0)
        : (math.min(screenSize.width, screenSize.height) * 0.36)
            .clamp(140.0, 280.0);
    final haloSize = photoSize * 1.54;
    final sidePadding = isMobile ? 24.0 : 40.0;
    // FittedBox measures its child at its natural, unbounded width before
    // scaling the result down — without this cap the Wrap below never
    // wraps (all five pills lay out in one long row) and the name/title
    // AutoSizeText render at full uncapped size, so that runaway natural
    // width becomes the widest thing in the block and drags the whole
    // block's scale factor down with it, shrinking the photo/halo too and
    // leaving the slack as dead space above and below.
    final contentWidth = screenSize.width - sidePadding * 2;

    return _CursorGlow(
      child: Container(
        // Fixed (not min-only) height: a bounded viewport-height box is
        // required for the Expanded below to lay out inside the page's
        // outer SingleChildScrollView, which otherwise hands Hero an
        // unbounded max height. Subtracts navbarClearance because
        // LandingPage already reserves that spacer above Hero — without
        // this, Hero's own full-viewport height pushes that same amount
        // of it (padding + scroll cue) below the first fold.
        height: screenSize.height - AppTheme.navbarClearance,
        // Asymmetric padding: generous at top (clears the floating navbar's
        // own breathing room), tight at bottom — the scroll cue belongs
        // right at the fold, not floating in a dead-space gap, so photo
        // and text can claim the freed height instead. Tighter sides on
        // mobile so the pill row and title get real width to work with.
        padding: EdgeInsets.fromLTRB(
          sidePadding,
          isMobile ? 48 : 64,
          sidePadding,
          20,
        ),
        child: Column(
          children: [
            Expanded(
              child: Center(
                // Scales the whole block down to fit whatever height is
                // actually available (short laptop screens, landscape
                // mobile) instead of overflowing — never clips, never
                // needs its own breakpoint ladder.
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: SizedBox(
                    width: contentWidth,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Profile photo, orbited by a slow rotating scanner-ring
                        // halo — the halo is a sibling behind it, not a wrapper, so
                        // MorphKeys.heroPhoto keeps measuring exactly the visible
                        // photo circle (unaffected by the halo's larger footprint).
                        _scaleIn(
                          0,
                          0.5,
                          Stack(
                            alignment: Alignment.center,
                            clipBehavior: Clip.none,
                            children: [
                              _RotatingHalo(size: haloSize),
                              _buildMorphFade(
                                fadeOut: true,
                                child: KeyedSubtree(
                                  key: MorphKeys.heroPhoto,
                                  child: Container(
                                    width: photoSize,
                                    height: photoSize,
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: const LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          AppTheme.primaryColor,
                                          AppTheme.accentColor
                                        ],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppTheme.primaryColor
                                              .withValues(alpha: 0.35),
                                          blurRadius: 24,
                                          spreadRadius: 2,
                                          offset: const Offset(-6, 0),
                                        ),
                                        BoxShadow(
                                          color: AppTheme.accentColor
                                              .withValues(alpha: 0.35),
                                          blurRadius: 24,
                                          spreadRadius: 2,
                                          offset: const Offset(6, 0),
                                        ),
                                      ],
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.all(3),
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppTheme.backgroundColor,
                                      ),
                                      child: ClipOval(
                                        child: Image.asset(
                                          widget.personalInfo.profileImage,
                                          width: double.infinity,
                                          height: double.infinity,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Container(
                                              color: AppTheme.surfaceColor,
                                              child: Icon(
                                                Icons.person,
                                                size: photoSize * 0.48,
                                                color: AppTheme.primaryColor,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Name/title trimmed a step down from full display
                        // scale — the photo+halo is the hero's one authored
                        // moment; text stays confident but cedes it room.
                        _riseIn(
                          0.35,
                          0.65,
                          AutoSizeText(
                            widget.personalInfo.name,
                            style: Theme.of(context)
                                .textTheme
                                .headlineLarge
                                ?.copyWith(
                                  color: AppTheme.primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                            maxLines: 1,
                          ),
                        ),
                        const SizedBox(height: 6),

                        // Title
                        _riseIn(
                          0.45,
                          0.75,
                          AutoSizeText(
                            widget.personalInfo.title,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  color: AppTheme.textPrimaryColor,
                                  fontWeight: FontWeight.w300,
                                ),
                            maxLines: 2,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 18),

                        // Signal tags replace the bio paragraph (already told in
                        // full in About) and the CTA buttons (contact belongs
                        // after the visitor has seen the work, not before).
                        // Genuine short list, so each tag gets its own capped
                        // stagger rather than fading in as one flat block.
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: isMobile ? 8 : 12,
                          runSpacing: isMobile ? 12 : 16,
                          children: [
                            for (final entry
                                in HeroSection._signals.asMap().entries)
                              _riseIn(
                                (0.6 + entry.key * 0.05).clamp(0.0, 1.0),
                                (0.75 + entry.key * 0.05).clamp(0.0, 1.0),
                                _buildSignalTag(context, entry.value),
                                by: 10,
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            _riseIn(0.8, 1.0, const _ScrollCue(), by: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildSignalTag(BuildContext context, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.primaryColor.withValues(alpha: 0.3),
        ),
      ),
      child: AutoSizeText(
        label,
        maxLines: 1,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.textPrimaryColor,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }

  // Fades this photo out (fadeOut: true) or in as the Hero↔About morph
  // (HeroAboutMorph) crosses its transition — hides fast on the hero
  // side, reveals fast on the about side, so the traveling overlay is
  // the only avatar visible mid-scroll.
  Widget _buildMorphFade({required bool fadeOut, required Widget child}) {
    final progress = widget.morphProgress;
    if (progress == null) return child;
    return AnimatedBuilder(
      animation: progress,
      builder: (context, _) {
        final t = progress.t;
        final opacity = fadeOut
            ? (1 - t / 0.15).clamp(0.0, 1.0)
            : ((t - 0.85) / 0.15).clamp(0.0, 1.0);
        return Opacity(opacity: opacity, child: child);
      },
      child: child,
    );
  }
}

/// Soft radial glow that follows the cursor within the Hero viewport —
/// Hero's own ambient touch (it previously had none of its own; its only
/// role was as the Hero→About morph's start point). Painted directly, not
/// via a rebuilt widget subtree, so mouse movement never triggers a Hero
/// rebuild.
class _CursorGlow extends StatefulWidget {
  final Widget child;

  const _CursorGlow({required this.child});

  @override
  State<_CursorGlow> createState() => _CursorGlowState();
}

class _CursorGlowState extends State<_CursorGlow> {
  final ValueNotifier<Offset?> _pos = ValueNotifier(null);

  @override
  void dispose() {
    _pos.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (event) => _pos.value = event.localPosition,
      onExit: (_) => _pos.value = null,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: IgnorePointer(
              child: ValueListenableBuilder<Offset?>(
                valueListenable: _pos,
                builder: (context, pos, _) {
                  if (pos == null) return const SizedBox.shrink();
                  return CustomPaint(painter: _GlowPainter(pos));
                },
              ),
            ),
          ),
          widget.child,
        ],
      ),
    );
  }
}

class _GlowPainter extends CustomPainter {
  final Offset center;

  _GlowPainter(this.center);

  @override
  void paint(Canvas canvas, Size size) {
    const radius = 260.0;
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          AppTheme.primaryColor.withValues(alpha: 0.1),
          AppTheme.primaryColor.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant _GlowPainter oldDelegate) =>
      oldDelegate.center != center;
}

/// A slow, continuously rotating scanner-ring behind the profile photo —
/// two partial arcs, not a closed ring, so it reads as "orbiting" rather
/// than a static badge. Amplifies the site's existing neon motif at full
/// strength for the one section that previously carried none of its own.
class _RotatingHalo extends StatefulWidget {
  final double size;

  const _RotatingHalo({required this.size});

  @override
  State<_RotatingHalo> createState() => _RotatingHaloState();
}

class _RotatingHaloState extends State<_RotatingHalo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 14),
      vsync: this,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.of(context).disableAnimations) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) => Transform.rotate(
          angle: _controller.value * 2 * math.pi,
          child: CustomPaint(
            size: Size.square(widget.size),
            painter: _HaloPainter(),
          ),
        ),
      ),
    );
  }
}

class _HaloPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    const gradient = SweepGradient(
      colors: [
        AppTheme.primaryColor,
        AppTheme.accentColor,
        AppTheme.primaryColor,
      ],
      stops: [0.0, 0.5, 1.0],
    );

    final outerRadius = size.width / 2;
    final outerRect = Rect.fromCircle(center: center, radius: outerRadius);
    final outerPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..shader = gradient.createShader(outerRect)
      ..color = Colors.white.withValues(alpha: 0.75);
    canvas.drawArc(outerRect, 0, math.pi * 1.1, false, outerPaint);

    final innerRadius = outerRadius - 16;
    final innerRect = Rect.fromCircle(center: center, radius: innerRadius);
    final innerPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round
      ..shader = gradient.createShader(innerRect)
      ..color = Colors.white.withValues(alpha: 0.4);
    canvas.drawArc(
        innerRect, math.pi * 0.85, math.pi * 0.65, false, innerPaint);
  }

  @override
  bool shouldRepaint(covariant _HaloPainter oldDelegate) => false;
}

/// Replaces the removed CTA row with an implicit next action: the visitor
/// is meant to scroll and explore, not be asked to contact/download yet.
class _ScrollCue extends StatefulWidget {
  const _ScrollCue();

  @override
  State<_ScrollCue> createState() => _ScrollCueState();
}

class _ScrollCueState extends State<_ScrollCue>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _nudge;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1400),
      vsync: this,
    );
    _nudge = Tween<double>(begin: 0, end: 8).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.of(context).disableAnimations) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _nudge,
      builder: (context, child) =>
          Transform.translate(offset: Offset(0, _nudge.value), child: child),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Scroll to explore',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondaryColor,
                  letterSpacing: 0.5,
                ),
          ),
          const SizedBox(height: 4),
          Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppTheme.primaryColor.withValues(alpha: 0.7),
          ),
        ],
      ),
    );
  }
}
