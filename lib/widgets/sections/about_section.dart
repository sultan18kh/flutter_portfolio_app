import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../../models/personal_info.dart';
import '../../models/education.dart';
import '../../utils/app_theme.dart';
import '../../utils/morph_keys.dart';
import '../../utils/photo_morph_progress.dart';
import '../now_cards.dart';
import '../section_heading.dart';

class AboutSection extends StatefulWidget {
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
  State<AboutSection> createState() => _AboutSectionState();
}

class _AboutSectionState extends State<AboutSection> {
  // Desktop only: the now-cards row (Spotify/Reading) has no natural height
  // of its own to match Education by — it's measured after each layout and
  // fed back in as an explicit height. Not circular: Education's height
  // depends only on its own content and column width, never on
  // _nowCardsHeight, so this always settles within one extra frame instead
  // of oscillating.
  final GlobalKey _bioRowKey = GlobalKey();
  final GlobalKey _educationKey = GlobalKey();
  double? _nowCardsHeight;

  @override
  void didUpdateWidget(covariant AboutSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.education != widget.education) {
      WidgetsBinding.instance.addPostFrameCallback(_measure);
    }
  }

  void _measure([Duration? _]) {
    final bioBox = _bioRowKey.currentContext?.findRenderObject() as RenderBox?;
    final eduBox =
        _educationKey.currentContext?.findRenderObject() as RenderBox?;
    if (bioBox == null || eduBox == null || !bioBox.hasSize) return;

    const bioToNowCardsGap = 24.0;
    final computed = eduBox.size.height - bioBox.size.height - bioToNowCardsGap;
    // Sane floor/ceiling — a real layout should never hit either, this is
    // just a guard against a degenerate first-frame measurement.
    final clamped = computed.clamp(160.0, 900.0);
    if (_nowCardsHeight == null || (clamped - _nowCardsHeight!).abs() > 0.5) {
      setState(() => _nowCardsHeight = clamped);
    }
  }

  @override
  Widget build(BuildContext context) {
    final personalInfo = widget.personalInfo;
    final education = widget.education;
    // Re-measure after every build (window resize, content/font-load
    // reflow) — cheap, and the only reliable way to keep the two columns
    // matched since IntrinsicHeight can't be used here (see now_cards.dart).
    WidgetsBinding.instance.addPostFrameCallback(_measure);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeading('About Me'),
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
                        color: AppTheme.textPrimaryColor.withValues(alpha: 0.8),
                        height: 1.6,
                      ),
                ),
              );
              final educationColumn = Column(
                key: _educationKey,
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
                // Mobile stacks Education below the now-cards instead of
                // beside them, so there's nothing to height-match here —
                // each card just uses its own default height.
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPortrait(),
                    const SizedBox(height: 32),
                    aboutText,
                    const SizedBox(height: 24),
                    const Column(
                      children: [
                        SpotifyTopTracksCard(),
                        SizedBox(height: 16),
                        ReadingRightNowCard(),
                      ],
                    ),
                    const SizedBox(height: 40),
                    educationColumn,
                  ],
                );
              }

              // Matches the Education column's actual rendered height
              // (measured post-frame, see _measure) so both columns end
              // flush — null on the very first frame, before anything has
              // been measured yet, in which case the cards just fall back
              // to their own default height for one frame.
              final nowCards = Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SpotifyTopTracksCard(height: _nowCardsHeight),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: ReadingRightNowCard(height: _nowCardsHeight),
                  ),
                ],
              );

              // Fixed width (not flex) for the whole left block — portrait,
              // bio, and now-cards all stack in one self-contained Column
              // here, sized to the same proportion the old 2:1 flex split
              // gave the bio card. Education sits in a separate Expanded
              // sibling below with its own independent height (three
              // stacked cards, taller than the bio+now-cards block); the
              // now-cards row is deliberately sized to match it exactly
              // (see _nowCardsHeight/_measure) so the two columns end flush
              // at the bottom instead of Education just trailing off lower.
              const asideWidth = 180.0;
              const asideGap = 40.0;
              const educationGap = 60.0;
              final availableForFlex =
                  constraints.maxWidth - asideWidth - asideGap - educationGap;
              final leftColumnWidth =
                  asideWidth + asideGap + availableForFlex * 2 / 3;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCoverBanner(),
                  const SizedBox(height: 48),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: leftColumnWidth,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              key: _bioRowKey,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildPortrait(),
                                const SizedBox(width: asideGap),
                                Expanded(child: aboutText),
                              ],
                            ),
                            const SizedBox(height: 24),
                            nowCards,
                          ],
                        ),
                      ),
                      const SizedBox(width: educationGap),
                      Expanded(child: educationColumn),
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
          errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
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
    final progress = widget.morphProgress;
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
          if (education.score.isNotEmpty) ...[
            const SizedBox(height: 4),
            AutoSizeText(
              education.score,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.accentColor,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ],
      ),
    );
  }
}
