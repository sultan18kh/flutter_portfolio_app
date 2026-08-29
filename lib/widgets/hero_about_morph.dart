import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../models/personal_info.dart';
import '../utils/app_theme.dart';
import '../utils/morph_keys.dart';
import '../utils/photo_morph_progress.dart';

/// Paints one traveling avatar that morphs — position, size, corner
/// radius, and source image all lerp together — from the Hero circle
/// photo into the About section's rounded portrait as the user scrolls
/// between them. [HeroSection] and [AboutSection] fade their own real
/// photo out/in around the edges of the transition so the handoff reads
/// as one object continuing its journey, not two images swapping.
class HeroAboutMorph extends StatelessWidget {
  final PhotoMorphProgress progress;
  final PersonalInfo personalInfo;

  const HeroAboutMorph({
    super.key,
    required this.progress,
    required this.personalInfo,
  });

  @override
  Widget build(BuildContext context) {
    // Positioned must be a direct-enough descendant of the ancestor Stack
    // (only Stateless/Stateful widgets in between — no other
    // RenderObjectWidget). IgnorePointer is a RenderObjectWidget, so it
    // has to sit *inside* Positioned's child, never wrapping it.
    return AnimatedBuilder(
      animation: progress,
      builder: (context, _) {
        final t = progress.t;
        if (t <= 0.0 || t >= 1.0) return const SizedBox.shrink();

        final heroBox = MorphKeys.heroPhoto.currentContext?.findRenderObject();
        final aboutBox =
            MorphKeys.aboutPhoto.currentContext?.findRenderObject();
        final originBox =
            MorphKeys.stackOrigin.currentContext?.findRenderObject();
        if (heroBox is! RenderBox ||
            !heroBox.attached ||
            aboutBox is! RenderBox ||
            !aboutBox.attached ||
            originBox is! RenderBox ||
            !originBox.attached) {
          return const SizedBox.shrink();
        }

        final heroTopLeft =
            originBox.globalToLocal(heroBox.localToGlobal(Offset.zero));
        final aboutTopLeft =
            originBox.globalToLocal(aboutBox.localToGlobal(Offset.zero));
        final topLeft = Offset.lerp(heroTopLeft, aboutTopLeft, t)!;
        final size = Size.lerp(heroBox.size, aboutBox.size, t)!;
        final radius = ui.lerpDouble(size.shortestSide / 2, 20, t)!;
        final glowAlpha = 1 - (2 * t - 1).abs(); // peaks mid-transition

        return Positioned(
          left: topLeft.dx,
          top: topLeft.dy,
          width: size.width,
          height: size.height,
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(radius),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor
                        .withValues(alpha: 0.35 * glowAlpha),
                    blurRadius: 30,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(radius),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Opacity(
                      opacity: 1 - t,
                      child: Image.asset(
                        personalInfo.profileImage,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            Container(color: AppTheme.surfaceColor),
                      ),
                    ),
                    Opacity(
                      opacity: t,
                      child: Image.asset(
                        'assets/sultan_side.jpg',
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            Container(color: AppTheme.surfaceColor),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
