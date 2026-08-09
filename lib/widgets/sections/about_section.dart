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
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: AspectRatio(
              aspectRatio: 4 / 1,
              child: Image.asset(
                'assets/sultan_cover_4_1.PNG',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const SizedBox.shrink(),
              ),
            ),
          ),
          const SizedBox(height: 48),
          LayoutBuilder(
            builder: (context, constraints) {
              final aboutText = AutoSizeText(
                personalInfo.profile,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppTheme.textPrimaryColor.withValues(alpha: 0.8),
                      height: 1.6,
                    ),
              );
              final educationColumn = Column(
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

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPortrait(),
                  const SizedBox(width: 40),
                  Expanded(flex: 2, child: aboutText),
                  const SizedBox(width: 60),
                  Expanded(flex: 1, child: educationColumn),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPortrait() {
    return Container(
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
