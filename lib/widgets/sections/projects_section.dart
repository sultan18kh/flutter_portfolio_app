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
          const RevealOnScroll(child: SectionHeading('Projects')),
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
    super.dispose();
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
                // Project header — a generative "fingerprint": one node
                // per technology (deterministically colored, so the same
                // tech reads as the same hue on every card), radiating
                // from a slowly-breathing hub. Distinct per project by
                // construction instead of a stock icon shared across all
                // of them.
                Container(
                  width: double.infinity,
                  height: 140,
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(
                    color: AppTheme.surfaceColor,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  child: AnimatedBuilder(
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
                // Project content
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AutoSizeText(
                        project.name,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                        maxLines: 1,
                      ),
                      const SizedBox(height: 8),
                      AutoSizeText(
                        project.description,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.textPrimaryColor
                                  .withValues(alpha: 0.8),
                            ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),
                      // Technologies
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: project.technologies
                            .take(4)
                            .map((tech) => _buildTechChip(context, tech))
                            .toList(),
                      ),
                      if (project.githubUrl != null ||
                          project.liveUrl != null) ...[
                        const SizedBox(height: 16),
                        // Action buttons
                        Row(
                          children: [
                            if (project.githubUrl != null)
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () =>
                                      _launchUrl(project.githubUrl!),
                                  icon: const Icon(Icons.code, size: 16),
                                  label: const Text('Code'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.primaryColor,
                                    foregroundColor: Colors.white,
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8),
                                  ),
                                ),
                              ),
                            if (project.githubUrl != null &&
                                project.liveUrl != null)
                              const SizedBox(width: 8),
                            if (project.liveUrl != null)
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () => _launchUrl(project.liveUrl!),
                                  icon: const Icon(Icons.launch, size: 16),
                                  label: const Text('Live'),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: AppTheme.primaryColor,
                                    side: const BorderSide(
                                        color: AppTheme.primaryColor),
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
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

  Widget _buildTechChip(BuildContext context, String tech) {
    final iconPath = widget.techIcons[tech.toLowerCase()];
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
            SvgPicture.asset(iconPath, width: 12, height: 12),
            const SizedBox(width: 4),
          ],
          AutoSizeText(
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

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
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
