import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/project.dart';
import '../../utils/app_theme.dart';
import '../reveal_on_scroll.dart';
import '../section_heading.dart';

class ProjectsSection extends StatelessWidget {
  final List<Project> projects;

  const ProjectsSection({
    super.key,
    required this.projects,
  });

  static const Map<String, String> _techIcons = {
    'flutter': 'assets/skills/flutter.svg',
    'dart': 'assets/skills/dart.svg',
    'node.js': 'assets/skills/node.svg',
    'python': 'assets/skills/python.svg',
    'git': 'assets/skills/git.svg',
    'github': 'assets/skills/github.svg',
    'firebase': 'assets/skills/firebase.svg',
    'graphql': 'assets/skills/graphql.svg',
    'azure': 'assets/skills/azure.svg',
    'android': 'assets/skills/android.svg',
    'ios': 'assets/skills/ios.svg',
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 80),
      child: Column(
        children: [
          const RevealOnScroll(child: SectionHeading('Portfolio')),
          const SizedBox(height: 60),
          LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = constraints.maxWidth < 700 ? 1 : 2;
              final width =
                  (constraints.maxWidth - (32 * (crossAxisCount - 1))) /
                      crossAxisCount;
              return Wrap(
                spacing: 32,
                runSpacing: 32,
                children: projects.asMap().entries.map((entry) {
                  final index = entry.key;
                  return SizedBox(
                    width: width.clamp(280, constraints.maxWidth),
                    child: RevealOnScroll(
                      delay: Duration(milliseconds: index * 90),
                      child: _ProjectCard(
                        project: entry.value,
                        techIcons: _techIcons,
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ProjectCard extends StatefulWidget {
  final Project project;
  final Map<String, String> techIcons;

  const _ProjectCard({
    required this.project,
    required this.techIcons,
  });

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late final AnimationController _pulseController;

  // Hover-intent preview (desktop): a deliberate delay before the centered
  // enlarged-image preview appears, so it reads as "I'm actually looking at
  // this one" rather than firing on every pass-through hover on the way to
  // somewhere else on the page.
  static const _hoverIntentDelay = Duration(seconds: 3);
  final _previewController = OverlayPortalController();
  Timer? _hoverIntentTimer;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.of(context).disableAnimations) {
      _pulseController.stop();
    } else if (!_pulseController.isAnimating) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _hoverIntentTimer?.cancel();
    super.dispose();
  }

  void _scheduleImagePreview() {
    _hoverIntentTimer?.cancel();
    _hoverIntentTimer = Timer(_hoverIntentDelay, () {
      if (mounted) _previewController.show();
    });
  }

  void _cancelImagePreview() {
    _hoverIntentTimer?.cancel();
    if (_previewController.isShowing) _previewController.hide();
  }

  void _openDetails(BuildContext context, Color accent) {
    _cancelImagePreview();
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Close',
      barrierColor: Colors.black.withValues(alpha: 0.75),
      transitionDuration:
          reduceMotion ? Duration.zero : const Duration(milliseconds: 220),
      pageBuilder: (context, _, __) => _ProjectDetailsDialog(
        project: widget.project,
        accentColor: accent,
        techIcons: widget.techIcons,
      ),
      transitionBuilder: (context, animation, _, child) => FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: Tween(begin: 0.94, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
          ),
          child: child,
        ),
      ),
    );
  }

  void _openLightbox(BuildContext context, String imagePath, Color accent) {
    // The hover-intent preview (desktop) and the tap target overlap on
    // hybrid mouse+touch input — always clear it before going full-screen
    // so it can never linger, ghosted, under the lightbox.
    _cancelImagePreview();
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Close',
      barrierColor: Colors.black.withValues(alpha: 0.85),
      transitionDuration:
          reduceMotion ? Duration.zero : const Duration(milliseconds: 220),
      pageBuilder: (context, _, __) =>
          _ImageLightbox(imagePath: imagePath, accentColor: accent),
      transitionBuilder: (context, animation, _, child) => FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: Tween(begin: 0.94, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
          ),
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final project = widget.project;
    final accentColor = _colorForTech(
      project.technologies.isNotEmpty ? project.technologies.first : '',
    );

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.02 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: accentColor.withValues(alpha: 0.3),
                      blurRadius: 28,
                      offset: const Offset(0, 12),
                    ),
                  ]
                : [],
          ),
          child: Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Project header: a real screenshot when one exists — framed
                // with the card's accent glow, hoverable (desktop) or
                // tappable (any input) to see it centered and full-size.
                // Cropped shorter than the source image's own aspect ratio
                // so the card stays compact; the preview/lightbox always
                // shows the uncropped original. Falls back to the
                // generative "fingerprint" (one node per technology,
                // deterministically colored, radiating from a
                // slowly-breathing hub) for any project without media yet.
                MouseRegion(
                  onEnter: (_) {
                    if (project.imageUrl != null) _scheduleImagePreview();
                  },
                  onExit: (_) => _cancelImagePreview(),
                  child: GestureDetector(
                    onTap: project.imageUrl == null
                        ? null
                        : () => _openLightbox(
                              context,
                              project.imageUrl!,
                              accentColor,
                            ),
                    child: OverlayPortal(
                      controller: _previewController,
                      overlayChildBuilder: (context) =>
                          _buildHoverPreview(context, accentColor),
                      child: AspectRatio(
                        aspectRatio: 2 / 1,
                        child: Container(
                          width: double.infinity,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceColor,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16),
                            ),
                            border: Border.all(
                              color: accentColor.withValues(alpha: 0.25),
                            ),
                          ),
                          child: project.imageUrl != null
                              ? Image.asset(
                                  project.imageUrl!,
                                  fit: BoxFit.cover,
                                )
                              : AnimatedBuilder(
                                  animation: _pulseController,
                                  builder: (context, _) => CustomPaint(
                                    size: Size.infinite,
                                    painter: _ProjectFingerprintPainter(
                                      project: project,
                                      pulse: _pulseController.value,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Project content — kept light on purpose: the screenshot
                // is the evidence now, this is just enough text to name
                // and place it.
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: AutoSizeText(
                              project.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: AppTheme.primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                              maxLines: 1,
                            ),
                          ),
                          const SizedBox(width: 8),
                          _PlatformBadges(platforms: project.platforms),
                          if (project.features.isNotEmpty) ...[
                            const SizedBox(width: 6),
                            _InfoButton(
                              onTap: () => _openDetails(context, accentColor),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 6),
                      AutoSizeText(
                        project.description,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.textSecondaryColor,
                            ),
                        maxLines: 2,
                      ),
                      const SizedBox(height: 12),
                      // Technologies
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: project.technologies
                            .take(3)
                            .map((tech) => _TechChip(
                                  tech: tech,
                                  iconPath:
                                      widget.techIcons[tech.toLowerCase()],
                                ))
                            .toList(),
                      ),
                      const SizedBox(height: 16),
                      _ProjectLinkActions(project: project),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Centered enlarged preview (desktop hover): the full, uncropped
  // screenshot in the middle of the viewport — same position a tap-opened
  // lightbox would use, just non-modal. Moving off the thumbnail
  // (`_cancelImagePreview`) dismisses it, no click needed, and it never
  // intercepts pointer events so the page stays fully interactive under it.
  Widget _buildHoverPreview(BuildContext context, Color accent) {
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    final size = MediaQuery.sizeOf(context);

    return Positioned.fill(
      child: IgnorePointer(
        child: Center(
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: reduceMotion
                ? Duration.zero
                : const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            builder: (context, t, child) => Opacity(
              opacity: t,
              child: Transform.scale(scale: 0.96 + (0.04 * t), child: child),
            ),
            child: Material(
              color: Colors.transparent,
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: math.min(1000, size.width - 96),
                  maxHeight: size.height * 0.8,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: accent.withValues(alpha: 0.5)),
                  boxShadow: [
                    BoxShadow(
                      color: accent.withValues(alpha: 0.35),
                      blurRadius: 40,
                      offset: const Offset(0, 16),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.asset(
                  widget.project.imageUrl!,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

}

Future<void> _launchUrl(String url) async {
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

// Platform-type badges shown next to a project's name — pure identity
// signal (what kind of product this is), never tappable. All four platforms
// share one chip treatment (same size, same cyan tint, same Material icon
// family already used throughout the app for contact rows and nav) so the
// row reads as one coherent set instead of a mismatched brand-color lineup.
class _PlatformBadges extends StatelessWidget {
  final List<ProjectPlatform> platforms;

  const _PlatformBadges({required this.platforms});

  @override
  Widget build(BuildContext context) {
    if (platforms.isEmpty) return const SizedBox.shrink();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: platforms
          .map((platform) => Padding(
                padding: const EdgeInsets.only(left: 6),
                child: Tooltip(
                  message: _label(platform),
                  child: Container(
                    width: 24,
                    height: 24,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.accentColor.withValues(alpha: 0.12),
                      border: Border.all(
                        color: AppTheme.accentColor.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Icon(
                      _iconData(platform),
                      size: 14,
                      color: AppTheme.accentColor,
                    ),
                  ),
                ),
              ))
          .toList(),
    );
  }

  String _label(ProjectPlatform platform) {
    switch (platform) {
      case ProjectPlatform.ios:
        return 'iOS';
      case ProjectPlatform.android:
        return 'Android';
      case ProjectPlatform.web:
        return 'Web App';
      case ProjectPlatform.aiAgent:
        return 'AI Agent';
    }
  }

  IconData _iconData(ProjectPlatform platform) {
    switch (platform) {
      case ProjectPlatform.ios:
        return Icons.apple;
      case ProjectPlatform.android:
        return Icons.android;
      case ProjectPlatform.web:
        return Icons.public;
      case ProjectPlatform.aiAgent:
        return Icons.smart_toy_outlined;
    }
  }
}

// Opens the full technical write-up (project.features) that the compact
// card has no room for — same circular-chip footprint as the platform
// badges next to it. Always the brand pink, not the card's own (hash-derived,
// so it varies project to project) accent — a consistent color here reads as
// "this control always does the same thing," where an accent tint would
// wrongly imply it means something different per card.
class _InfoButton extends StatefulWidget {
  final VoidCallback onTap;

  const _InfoButton({required this.onTap});

  @override
  State<_InfoButton> createState() => _InfoButtonState();
}

class _InfoButtonState extends State<_InfoButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'View technical details',
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 24,
            height: 24,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.primaryColor
                  .withValues(alpha: _isHovered ? 0.24 : 0.12),
              border: Border.all(
                color: AppTheme.primaryColor
                    .withValues(alpha: _isHovered ? 0.7 : 0.3),
              ),
            ),
            child: const Icon(
              Icons.info_outline_rounded,
              size: 14,
              color: AppTheme.primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}

// Per-project link action(s): store buttons, a site link, or — for anything
// with no shareable link — a confidential indicator. Compact, naturally-sized
// pills wrapped left (never a stretched full-width button) — the same
// left-flush, intrinsic-width rhythm as the tech chips directly above them.
class _ProjectLinkActions extends StatelessWidget {
  final Project project;

  const _ProjectLinkActions({required this.project});

  @override
  Widget build(BuildContext context) {
    final hasStoreLink =
        project.appStoreUrl != null || project.playStoreUrl != null;

    if (hasStoreLink) {
      return Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          if (project.appStoreUrl != null)
            _LinkButton(
              icon: Icons.apple,
              label: 'App Store',
              onPressed: () => _launchUrl(project.appStoreUrl!),
            ),
          if (project.playStoreUrl != null)
            _LinkButton(
              icon: Icons.play_circle_outline_rounded,
              label: 'Google Play',
              onPressed: () => _launchUrl(project.playStoreUrl!),
            ),
        ],
      );
    }

    if (project.siteUrl != null) {
      return _LinkButton(
        icon: Icons.public,
        label: 'Visit Site',
        onPressed: () => _launchUrl(project.siteUrl!),
      );
    }

    return const _ConfidentialChip();
  }
}

// A compact glass pill — the system's resting-glow/amplify-on-hover
// vocabulary (see DESIGN.md Elevation & Depth, and _ContactItemButton /
// _AlphaBoldCredit for the same treatment) instead of a generic Material
// OutlinedButton, which reads flat and dated next to the rest of the page.
class _LinkButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _LinkButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  State<_LinkButton> createState() => _LinkButtonState();
}

class _LinkButtonState extends State<_LinkButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor
                .withValues(alpha: _isHovered ? 0.16 : 0.08),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: AppTheme.primaryColor
                  .withValues(alpha: _isHovered ? 0.6 : 0.25),
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: AppTheme.primaryColor.withValues(alpha: 0.3),
                      blurRadius: 16,
                      spreadRadius: 1,
                    ),
                  ]
                : const [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, size: 15, color: AppTheme.primaryColor),
              const SizedBox(width: 6),
              Text(
                widget.label,
                style: const TextStyle(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 12.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Deliberately NOT a disabled button — a plain button that looks disabled
// still signals "you could try this," which is the wrong message for a
// link that will never work. This reads instead as a quiet inline status
// indicator: same compact pill shape as _LinkButton for family consistency,
// but static and muted-lavender (DESIGN.md's own "quietest text tier") —
// never gains a hover glow, since it isn't interactive-relevant.
class _ConfidentialChip extends StatelessWidget {
  const _ConfidentialChip();

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Confidential — link cannot be shared',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: AppTheme.textMutedColor.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: AppTheme.textMutedColor.withValues(alpha: 0.25),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.lock_rounded, size: 15, color: AppTheme.textMutedColor),
            const SizedBox(width: 6),
            Text(
              'Confidential',
              style: TextStyle(
                color: AppTheme.textMutedColor,
                fontWeight: FontWeight.w600,
                fontSize: 12.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Full-size image view, opened by tapping a project screenshot (the
// primary interaction on touch, and available on desktop too). Tap
// anywhere outside the framed image, tap the close button, or use the
// dialog barrier to dismiss.
class _ImageLightbox extends StatelessWidget {
  final String imagePath;
  final Color accentColor;

  const _ImageLightbox({required this.imagePath, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Material(
        type: MaterialType.transparency,
        child: SizedBox.expand(
          child: Stack(
            children: [
              Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: math.min(1100, size.width - 48),
                    maxHeight: size.height * 0.85,
                  ),
                  child: GestureDetector(
                    onTap: () {}, // absorb taps on the image itself
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: accentColor.withValues(alpha: 0.4),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: accentColor.withValues(alpha: 0.35),
                            blurRadius: 40,
                            offset: const Offset(0, 16),
                          ),
                        ],
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Image.asset(imagePath, fit: BoxFit.contain),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 24,
                right: 24,
                child: IconButton.filled(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                  style: IconButton.styleFrom(
                    backgroundColor:
                        AppTheme.surfaceColor.withValues(alpha: 0.8),
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// The full technical write-up for one project — everything the compact
// card's 2-line description and 3-chip tech row can't fit: the untruncated
// description, every technology, and the full `features` bullet list. Same
// glass/accent-glow dialog language as `_ImageLightbox`.
class _ProjectDetailsDialog extends StatelessWidget {
  final Project project;
  final Color accentColor;
  final Map<String, String> techIcons;

  const _ProjectDetailsDialog({
    required this.project,
    required this.accentColor,
    required this.techIcons,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Material(
        type: MaterialType.transparency,
        child: SizedBox.expand(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: math.min(640, size.width - 48),
                maxHeight: size.height * 0.85,
              ),
              child: GestureDetector(
                onTap: () {}, // absorb taps on the panel itself
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: accentColor.withValues(alpha: 0.4),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: accentColor.withValues(alpha: 0.3),
                        blurRadius: 40,
                        offset: const Offset(0, 16),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 20, 16, 0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                project.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      color: accentColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                            _PlatformBadges(platforms: project.platforms),
                            IconButton(
                              onPressed: () => Navigator.of(context).pop(),
                              icon: const Icon(Icons.close),
                              color: AppTheme.textSecondaryColor,
                              visualDensity: VisualDensity.compact,
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                project.description,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: AppTheme.textSecondaryColor,
                                      height: 1.5,
                                    ),
                              ),
                              const SizedBox(height: 16),
                              Wrap(
                                spacing: 6,
                                runSpacing: 6,
                                children: project.technologies
                                    .map((tech) => _TechChip(
                                          tech: tech,
                                          iconPath:
                                              techIcons[tech.toLowerCase()],
                                        ))
                                    .toList(),
                              ),
                              if (project.features.isNotEmpty) ...[
                                const SizedBox(height: 20),
                                Text(
                                  'Under the hood',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge
                                      ?.copyWith(
                                        color: accentColor,
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                                const SizedBox(height: 10),
                                ...project.features.map(
                                  (feature) => Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 10),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 6),
                                          child: Container(
                                            width: 5,
                                            height: 5,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: accentColor,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            feature,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  color: AppTheme
                                                      .textPrimaryColor
                                                      .withValues(alpha: 0.85),
                                                  height: 1.5,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                              const SizedBox(height: 16),
                              _ProjectLinkActions(project: project),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Standalone tech chip (not tied to a hoverable card) used in the details
// dialog's full technology list — same look as `_ProjectCard`'s chip, minus
// the card-state dependency.
class _TechChip extends StatelessWidget {
  final String tech;
  final String? iconPath;

  const _TechChip({required this.tech, required this.iconPath});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (iconPath != null) ...[
            SvgPicture.asset(iconPath!, width: 12, height: 12),
            const SizedBox(width: 4),
          ],
          Text(
            tech,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.primaryColor,
                  fontSize: 10,
                ),
          ),
        ],
      ),
    );
  }
}

// Deterministic per-tech hue so the same technology always reads as the
// same color across every project card, not just within one. Walks the
// full brand triad (not just a two-color lerp) so hashes spread across
// visibly distinct hues instead of clustering in one narrow band.
Color _colorForTech(String tech) {
  if (tech.isEmpty) return AppTheme.primaryColor;
  const stops = [
    AppTheme.primaryColor,
    AppTheme.accentColor,
    AppTheme.secondaryColor,
    AppTheme.primaryColor,
  ];
  final t = (tech.toLowerCase().hashCode % 1000) / 1000.0;
  final scaled = t * (stops.length - 1);
  final i = scaled.floor();
  return Color.lerp(stops[i], stops[i + 1], scaled - i)!;
}

/// Paints one project's technology stack as a small hub-and-spoke
/// constellation: a breathing hub node (the project itself) radiating one
/// satellite per technology. Node layout is seeded from the project's
/// name, so it's stable across rebuilds but distinct project to project —
/// a real fingerprint of the work instead of a stock icon shared by all.
class _ProjectFingerprintPainter extends CustomPainter {
  final Project project;
  final double pulse;

  _ProjectFingerprintPainter({required this.project, required this.pulse});

  @override
  void paint(Canvas canvas, Size size) {
    final rnd = math.Random(project.name.hashCode);

    // Background wash, tinted toward the project's lead technology.
    final leadColor = _colorForTech(
      project.technologies.isNotEmpty ? project.technologies.first : '',
    );
    final bg = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppTheme.surfaceColor,
          Color.lerp(AppTheme.surfaceColor, leadColor, 0.28)!,
        ],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, bg);

    // Ambient dust — ties the card into the page's particle motif without
    // competing with the hub/satellite structure that carries the meaning.
    final dust = Paint()..style = PaintingStyle.fill;
    for (var i = 0; i < 16; i++) {
      final p = Offset(
        rnd.nextDouble() * size.width,
        rnd.nextDouble() * size.height,
      );
      dust.color =
          Colors.white.withValues(alpha: 0.04 + rnd.nextDouble() * 0.05);
      canvas.drawCircle(p, 1 + rnd.nextDouble() * 1.5, dust);
    }

    final hub = Offset(
      size.width * (0.3 + rnd.nextDouble() * 0.4),
      size.height * (0.32 + rnd.nextDouble() * 0.3),
    );

    final techs = project.technologies.take(6).toList();
    final satellites = <Offset>[];
    final linePaint = Paint()
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    for (var i = 0; i < techs.length; i++) {
      final angle = (i / techs.length) * 2 * math.pi + rnd.nextDouble() * 0.4;
      final radius = size.height * (0.42 + (i % 3) * 0.08);
      final raw = hub +
          Offset(math.cos(angle) * radius, math.sin(angle) * radius * 0.6);
      final pos = Offset(
        raw.dx.clamp(10, size.width - 10),
        raw.dy.clamp(10, size.height - 10),
      );
      satellites.add(pos);

      final color = _colorForTech(techs[i]);
      linePaint.color = color.withValues(alpha: 0.35);
      canvas.drawLine(hub, pos, linePaint);
    }

    for (var i = 0; i < satellites.length; i++) {
      final color = _colorForTech(techs[i]);
      final glow = Paint()
        ..color = color.withValues(alpha: 0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
      canvas.drawCircle(satellites[i], 7, glow);
      final node = Paint()..color = color.withValues(alpha: 0.9);
      canvas.drawCircle(satellites[i], 4, node);
    }

    // Hub: a slow breathing glow (pulse cycles 0..1..0 via the controller's
    // reverse repeat) so the fingerprint reads as alive, not a static
    // badge. Colored by the lead technology, not a fixed brand color, so
    // the card's single brightest element also carries its identity.
    final hubGlowRadius = 15 + pulse * 7;
    final hubGlow = Paint()
      ..shader = RadialGradient(colors: [
        leadColor.withValues(alpha: 0.55),
        leadColor.withValues(alpha: 0.0),
      ]).createShader(Rect.fromCircle(center: hub, radius: hubGlowRadius));
    canvas.drawCircle(hub, hubGlowRadius, hubGlow);

    canvas.drawCircle(hub, 9, Paint()..color = leadColor);
    canvas.drawCircle(
      hub,
      6,
      Paint()..color = Colors.white.withValues(alpha: 0.95),
    );
  }

  @override
  bool shouldRepaint(covariant _ProjectFingerprintPainter oldDelegate) =>
      oldDelegate.pulse != pulse || oldDelegate.project != project;
}
