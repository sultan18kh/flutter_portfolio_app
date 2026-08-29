import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../../models/personal_info.dart';
import '../../models/education.dart';
import '../../utils/app_theme.dart';
import '../../utils/morph_keys.dart';
import '../../utils/photo_morph_progress.dart';

class AboutSection extends StatelessWidget {
  final PersonalInfo personalInfo;
  final List<Education> education;
  final PhotoMorphProgress? morphProgress;

  const AboutSection({
    super.key,
    required this.personalInfo,
    required this.education,
    this.morphProgress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('About Me'),
          const SizedBox(height: 40),
          LayoutBuilder(
            builder: (context, constraints) {
              final aboutText = Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.primaryColor.withValues(alpha: 0.2),
                  ),
                ),
                child: AutoSizeText(
                  personalInfo.aboutBio,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color:
                            AppTheme.textPrimaryColor.withValues(alpha: 0.8),
                        height: 1.6,
                      ),
                ),
              );
              final educationColumn = Column(
                // Stretch, not start — otherwise each card shrink-wraps to
                // its own text width instead of matching the others (short
                // "A Levels" ends up narrower than "Bachelor of Science...").
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AutoSizeText(
                    'Education',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 20),
                  ...education.map((edu) => _buildEducationCard(context, edu)),
                ],
              );

              if (constraints.maxWidth < 800) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPortrait(),
                    const SizedBox(height: 32),
                    aboutText,
                    const SizedBox(height: 40),
                    educationColumn,
                  ],
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCoverBanner(),
                  const SizedBox(height: 48),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPortrait(),
                      const SizedBox(width: 40),
                      Expanded(flex: 2, child: aboutText),
                      const SizedBox(width: 60),
                      Expanded(flex: 1, child: educationColumn),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCoverBanner() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: AspectRatio(
        aspectRatio: 4 / 1,
        child: Image.asset(
          'assets/sultan_cover.webp',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              const SizedBox.shrink(),
        ),
      ),
    );
  }

  Widget _buildPortrait() {
    final portrait = KeyedSubtree(
      key: MorphKeys.aboutPhoto,
      child: Container(
        width: 180,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppTheme.primaryColor, AppTheme.accentColor],
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryColor.withValues(alpha: 0.25),
              blurRadius: 24,
              offset: const Offset(-4, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(17),
          child: AspectRatio(
            aspectRatio: 3 / 4,
            child: Image.asset(
              'assets/sultan_side.jpg',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  Container(color: AppTheme.surfaceColor),
            ),
          ),
        ),
      ),
    );

    // Reveals fast once the Hero→About morph (HeroAboutMorph) lands here,
    // so the traveling overlay hands off to the real portrait seamlessly.
    final progress = morphProgress;
    if (progress == null) return portrait;
    return AnimatedBuilder(
      animation: progress,
      builder: (context, child) {
        final opacity = ((progress.t - 0.85) / 0.15).clamp(0.0, 1.0);
        return Opacity(opacity: opacity, child: child);
      },
      child: portrait,
    );
  }

  Widget _buildSectionTitle(String title) {
    return Builder(
      builder: (context) => AutoSizeText(
        title,
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  Widget _buildEducationCard(BuildContext context, Education education) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.primaryColor.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoSizeText(
            education.degree,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          AutoSizeText(
            education.institution,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textPrimaryColor,
                ),
          ),
          const SizedBox(height: 4),
          AutoSizeText(
            education.period,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.textPrimaryColor.withValues(alpha: 0.7),
                ),
          ),
        ],
      ),
    );
  }
}
