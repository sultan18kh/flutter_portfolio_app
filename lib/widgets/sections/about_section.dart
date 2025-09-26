import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../../models/personal_info.dart';
import '../../models/education.dart';
import '../../utils/app_theme.dart';

class AboutSection extends StatelessWidget {
  final PersonalInfo personalInfo;
  final List<Education> education;

  const AboutSection({
    super.key,
    required this.personalInfo,
    required this.education,
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // About content
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeText(
                      personalInfo.profile,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppTheme.textPrimaryColor
                                .withValues(alpha: 0.8),
                            height: 1.6,
                          ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
              const SizedBox(width: 60),
              // Education
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeText(
                      'Education',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 20),
                    ...education
                        .map((edu) => _buildEducationCard(context, edu)),
                  ],
                ),
              ),
            ],
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
