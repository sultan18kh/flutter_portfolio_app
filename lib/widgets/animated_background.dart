import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../utils/app_theme.dart';

class AnimatedBackground extends StatefulWidget {
  final Widget child;
  final ScrollController? scrollController;

  const AnimatedBackground({
    super.key,
    required this.child,
    this.scrollController,
  });

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with TickerProviderStateMixin {
  late AnimationController _particleController;
  late AnimationController _gradientController;
  late AnimationController _smokeController;
  late DateTime _smokeStartTime;
  late List<Particle> _particles;
  late List<SmokeWisp> _smokeWisps;
  double _smoothedScrollOffset = 0;
  bool _reduceMotion = false;

  // Real seconds one full crossing takes once the burst has settled —
  // matches _smokeController's own duration, kept as a named constant
  // since the controller's value is no longer read directly for position.
  static const double _smokeCycleSeconds = 18;

  // Smoke bursts in fast on load, then eases down to that steady cruising
  // speed. Modeled as extra "virtual" distance added on top of real
  // elapsed time, front-loaded by an exponential decay — velocity starts
  // at 1 + boost/decay (a multiple of normal speed) and relaxes toward 1
  // as elapsed time passes a few multiples of decaySeconds. No state
  // machine, no reset: the boost term just fades below noticeability.
  static const double _smokeBurstBoostSeconds = 6;
  static const double _smokeBurstDecaySeconds = 2.5;

  @override
  void initState() {
    super.initState();

    _particleController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..addListener(_followScroll);

    _gradientController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    );

    // Smoke never stops: each wisp perpetually crosses the screen from its
    // home edge to the far edge, fading in as it enters and out as it
    // exits, then re-enters from the same edge for another pass — blue
    // always travels left-to-right, pink always right-to-left.
    _smokeController = AnimationController(
      duration: const Duration(seconds: 18),
      vsync: this,
    );
    _smokeStartTime = DateTime.now();

    // * Initialize particles with a placeholder size, will be updated in build
    _particles = [];
    _smokeWisps = [];
  }

  // Lets the background drift a little slower than the page scrolls — a
  // damped follow (not a 1:1 parallax) so depth reads as ambient, not as
  // a competing motion against page content.
  void _followScroll() {
    if (_reduceMotion) return;
    final controller = widget.scrollController;
    if (controller == null || !controller.hasClients) return;
    _smoothedScrollOffset += (controller.offset - _smoothedScrollOffset) * 0.08;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Respect the OS-level "reduce motion" setting: keep the static
    // gradient/particle layout but stop animating it.
    _reduceMotion = MediaQuery.of(context).disableAnimations;
    if (_reduceMotion) {
      _particleController.stop();
      _gradientController.stop();
      _smokeController.stop();
    } else {
      if (!_particleController.isAnimating) {
        _particleController.repeat();
        _gradientController.repeat();
      }
      if (!_smokeController.isAnimating) {
        _smokeController.repeat();
      }
    }
  }

  @override
  void dispose() {
    _particleController.dispose();
    _gradientController.dispose();
    _smokeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    // Generate particles based on actual screen size if not already generated
    if (_particles.isEmpty) {
      _particles = List.generate(50, (index) => Particle.random(screenSize));
    }
    if (_smokeWisps.isEmpty) {
      _smokeWisps = List.generate(16, (index) => SmokeWisp.random(screenSize));
    }

    return Stack(
      children: [
        // Animated gradient background
        AnimatedBuilder(
          animation: _gradientController,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: const [
                    AppTheme.backgroundColor,
                    AppTheme.surfaceColor,
                    AppTheme.surfaceColor,
                    AppTheme.backgroundColor,
                  ],
                  stops: [
                    _gradientController.lowerBound,
                    _gradientController.value,
                    _gradientController.value,
                    _gradientController.upperBound,
                  ],
                ),
              ),
            );
          },
        ),

        // Floating particles
        AnimatedBuilder(
          animation: _particleController,
          builder: (context, child) {
            return SizedBox(
              width: screenSize.width,
              height: screenSize.height,
              child: CustomPaint(
                painter: ParticlePainter(
                  particles: _particles,
                  animation: _particleController.value,
                  scrollOffset: _smoothedScrollOffset,
                ),
              ),
            );
          },
        ),

        // Smoke: each wisp continuously crosses the screen from its home
        // edge to the far one and loops — never settles, never stops.
        // _smokeController itself is just the per-frame pulse here; actual
        // position comes from wall-clock elapsed time so the burst-then-
        // settle speed ramp below can run smoothly across the whole
        // session instead of resetting every time the controller loops.
        AnimatedBuilder(
          animation: _smokeController,
          builder: (context, child) {
            final elapsed =
                DateTime.now().difference(_smokeStartTime).inMicroseconds / 1e6;
            final warpedElapsed = elapsed +
                _smokeBurstBoostSeconds *
                    (1 - math.exp(-elapsed / _smokeBurstDecaySeconds));
            return SizedBox(
              width: screenSize.width,
              height: screenSize.height,
              child: CustomPaint(
                painter: SmokeBurstPainter(
                  wisps: _smokeWisps,
                  progress: warpedElapsed / _smokeCycleSeconds,
                ),
              ),
            );
          },
        ),

        // Content
        widget.child,
      ],
    );
  }
}

class Particle {
  final double x;
  final double y;
  final double size;
  final double speed;
  final double angle;
  final Color color;

  Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.angle,
    required this.color,
  });

  factory Particle.random(Size screenSize) {
    final hue =
        math.Random().nextBool() ? AppTheme.primaryColor : AppTheme.accentColor;
    return Particle(
      x: math.Random().nextDouble() * screenSize.width,
      y: math.Random().nextDouble() * screenSize.height,
      size: math.Random().nextDouble() * 3 + 1,
      speed: math.Random().nextDouble() * 0.5 + 0.1,
      angle: math.Random().nextDouble() * 2 * math.pi,
      color: hue.withValues(alpha: math.Random().nextDouble() * 0.3 + 0.1),
    );
  }
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double animation;
  final double scrollOffset;

  ParticlePainter({
    required this.particles,
    required this.animation,
    this.scrollOffset = 0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      final paint = Paint()
        ..color = particle.color
        ..style = PaintingStyle.fill;

      // Calculate movement based on angle and speed
      final dx = math.cos(particle.angle) * particle.speed * animation * 100;
      final dy = math.sin(particle.angle) * particle.speed * animation * 100;

      // Bigger particles read as closer, so they drift further per pixel
      // scrolled — a cheap depth cue, kept subtle so it's felt, not seen.
      final depthFactor = (particle.size / 4.0).clamp(0.3, 1.0);
      final parallaxDy = scrollOffset * depthFactor * 0.06;

      // Wrap particles around screen edges
      final x = (particle.x + dx) % size.width;
      final y = (particle.y + dy - parallaxDy) % size.height;

      canvas.drawCircle(
        Offset(x, y < 0 ? y + size.height : y),
        particle.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) => true;
}

/// A single soft smoke puff that perpetually crosses the screen from its
/// home edge to the far one, fading in as it enters and out as it exits,
/// then re-entering from the same edge for another pass — it never
/// settles and never stops moving.
class SmokeWisp {
  final bool fromLeft;
  final double startY;
  final double verticalAmplitude;
  final double verticalPhase;
  final double size;
  final double peakAlpha;
  final double phase;
  final double speed;

  SmokeWisp({
    required this.fromLeft,
    required this.startY,
    required this.verticalAmplitude,
    required this.verticalPhase,
    required this.size,
    required this.peakAlpha,
    required this.phase,
    required this.speed,
  });

  // Blue (accent) always travels from the left edge to the right; pink
  // (primary) always travels from the right edge to the left. The two
  // colors never cross sides.
  Color get color => fromLeft ? AppTheme.accentColor : AppTheme.primaryColor;

  factory SmokeWisp.random(Size screenSize) {
    final random = math.Random();
    return SmokeWisp(
      fromLeft: random.nextBool(),
      startY: random.nextDouble() * screenSize.height,
      verticalAmplitude: 30 + random.nextDouble() * 60,
      verticalPhase: random.nextDouble() * 2 * math.pi,
      size: 40 + random.nextDouble() * 50,
      peakAlpha: 0.10 + random.nextDouble() * 0.14,
      // Small stagger so the first pass still reads as a burst arriving
      // from the edges, not one synchronized wall of smoke; every pass
      // after loops naturally from the same formula.
      phase: random.nextDouble() * 0.35,
      speed: 0.7 + random.nextDouble() * 0.7,
    );
  }
}

/// Paints the smoke: each wisp's horizontal position is a full crossing of
/// the screen driven by the looping [progress] clock — [SmokeWisp.speed]
/// and [SmokeWisp.phase] desync the wisps from each other so crossings
/// never lock-step, and each fades in/out via a sine envelope that hits
/// zero exactly at both off-screen endpoints, so the loop reset is
/// invisible.
class SmokeBurstPainter extends CustomPainter {
  final List<SmokeWisp> wisps;
  final double progress;

  SmokeBurstPainter({required this.wisps, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    for (final wisp in wisps) {
      final cycleT = (progress * wisp.speed + wisp.phase) % 1.0;
      final eased = Curves.easeInOut.transform(cycleT);

      final margin = wisp.size;
      final x = wisp.fromLeft
          ? -margin + (size.width + margin * 2) * eased
          : size.width + margin - (size.width + margin * 2) * eased;
      final y = wisp.startY +
          math.sin(cycleT * 2 * math.pi + wisp.verticalPhase) *
              wisp.verticalAmplitude;

      // Zero at cycleT 0 and 1 (off-screen), peak at the midpoint — the
      // puff is always fully faded before the loop resets it.
      final opacity = wisp.peakAlpha * math.sin(math.pi * cycleT);
      if (opacity <= 0) continue;

      final paint = Paint()
        ..color = wisp.color.withValues(alpha: opacity)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, wisp.size * 0.5);
      canvas.drawCircle(Offset(x, y), wisp.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant SmokeBurstPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
