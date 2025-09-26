import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/project.dart';
import '../../utils/app_theme.dart';

class ProjectsSection extends StatelessWidget {
  final List<Project> projects;

  const ProjectsSection({
    super.key,
    required this.projects,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 80),
      child: Column(
        children: [
          _buildSectionTitle('Projects'),
          const SizedBox(height: 60),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 32,
              mainAxisSpacing: 32,
              childAspectRatio: 0.8,
            ),
            itemCount: projects.length,
            itemBuilder: (context, index) =>
                _buildProjectCard(context, projects[index]),
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

  Widget _buildProjectCard(BuildContext context, Project project) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Project header
          Container(
            width: double.infinity,
            height: 160,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
              ),
            ),
            child: Center(
              child: Icon(
                Icons.code,
                size: 60,
                color: Colors.white,
              ),
            ),
          ),
          // Project content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                          color:
                              AppTheme.textPrimaryColor.withValues(alpha: 0.8),
                        ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  // Technologies
                  Expanded(
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: project.technologies
                          .take(4)
                          .map((tech) => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryColor
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: AutoSizeText(
                                  tech,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: AppTheme.primaryColor,
                                        fontSize: 10,
                                      ),
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Action buttons
                  Row(
                    children: [
                      if (project.githubUrl != null)
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _launchUrl(project.githubUrl!),
                            icon: const Icon(Icons.code, size: 16),
                            label: const Text('Code'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 8),
                            ),
                          ),
                        ),
                      if (project.githubUrl != null && project.liveUrl != null)
                        const SizedBox(width: 8),
                      if (project.liveUrl != null)
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _launchUrl(project.liveUrl!),
                            icon: const Icon(Icons.launch, size: 16),
                            label: const Text('Live'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppTheme.primaryColor,
                              side: BorderSide(color: AppTheme.primaryColor),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
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
