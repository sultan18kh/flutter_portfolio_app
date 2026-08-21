import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/project.dart';
import '../../utils/app_theme.dart';
import '../reveal_on_scroll.dart';

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

  static const List<(IconData, List<Color>)> _headerStyles = [
    (Icons.groups_rounded, [AppTheme.primaryColor, AppTheme.accentColor]),
    (Icons.timer_rounded, [AppTheme.accentColor, AppTheme.primaryColor]),
    (
      Icons.emoji_events_rounded,
      [AppTheme.primaryColor, AppTheme.secondaryColor]
    ),
    (Icons.task_alt_rounded, [AppTheme.secondaryColor, AppTheme.accentColor]),
    (Icons.shield_rounded, [AppTheme.accentColor, AppTheme.secondaryColor]),
    (Icons.speed_rounded, [AppTheme.secondaryColor, AppTheme.primaryColor]),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 80),
      child: Column(
        children: [
          RevealOnScroll(child: _buildSectionTitle('Projects')),
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
                        headerStyle:
                            _headerStyles[index % _headerStyles.length],
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
}

class _ProjectCard extends StatefulWidget {
  final Project project;
  final (IconData, List<Color>) headerStyle;
  final Map<String, String> techIcons;

  const _ProjectCard({
    required this.project,
    required this.headerStyle,
    required this.techIcons,
  });

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final (icon, colors) = widget.headerStyle;
    final project = widget.project;

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
                      color: colors.first.withValues(alpha: 0.3),
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
                // Project header
                Container(
                  width: double.infinity,
                  height: 140,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: colors,
                    ),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      icon,
                      size: 56,
                      color: Colors.white.withValues(alpha: 0.9),
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
