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
  late List<Particle> _particles;
  double _smoothedScrollOffset = 0;
  bool _reduceMotion = false;

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

    // * Initialize particles with a placeholder size, will be updated in build
    _particles = [];
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
    } else if (!_particleController.isAnimating) {
      _particleController.repeat();
      _gradientController.repeat();
    }
  }

  @override
  void dispose() {
    _particleController.dispose();
    _gradientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    // Generate particles based on actual screen size if not already generated
    if (_particles.isEmpty) {
      _particles = List.generate(50, (index) => Particle.random(screenSize));
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
