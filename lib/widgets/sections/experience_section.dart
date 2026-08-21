import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../../models/experience.dart';
import '../../utils/app_theme.dart';
import '../reveal_on_scroll.dart';

class ExperienceSection extends StatelessWidget {
  final List<Experience> experience;

  const ExperienceSection({
    super.key,
    required this.experience,
  });

  static const Map<String, String> _companyLogos = {
    'AlphaBOLD': 'assets/companies/alphabold.png',
    'We > I': 'assets/companies/we_over_i.jpeg',
    'Confiz Limited': 'assets/companies/confiz.jpeg',
    'Finz Technologies': 'assets/companies/finz.jpeg',
    'Fauji Fertilizer Company': 'assets/companies/ffc.png',
    'Netsol Technologies': 'assets/companies/netsol.png',
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RevealOnScroll(child: _buildSectionTitle('Experience')),
          const SizedBox(height: 60),
          ...experience.asMap().entries.map((entry) {
            final index = entry.key;
            final exp = entry.value;
            return RevealOnScroll(
              delay: Duration(milliseconds: index * 90),
              child: _buildExperienceCard(context, exp),
            );
          }),
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

  Widget _buildTimelineBadge(String company) {
    final path = _companyLogos[company];
    return Container(
      width: 60,
      height: 60,
      padding: path != null ? const EdgeInsets.all(10) : EdgeInsets.zero,
      decoration: BoxDecoration(
        color: path != null ? Colors.white : AppTheme.primaryColor,
        shape: BoxShape.circle,
        border: Border.all(
          color: AppTheme.primaryColor,
          width: 2.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withValues(alpha: 0.35),
            blurRadius: 16,
            spreadRadius: 1,
          ),
        ],
      ),
      child: path == null
          ? const Icon(Icons.work_rounded, color: Colors.white, size: 26)
          : ClipOval(
              child: Image.asset(
                path,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.work_rounded, color: AppTheme.primaryColor),
              ),
            ),
    );
  }

  Widget _buildExperienceCard(BuildContext context, Experience exp) {
    return Container(
      margin: const EdgeInsets.only(bottom: 32),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Timeline indicator — company logo instead of a number
              _buildTimelineBadge(exp.company),
              const SizedBox(width: 30),
              // Experience content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeText(
                      exp.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    AutoSizeText(
                      exp.company,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppTheme.textPrimaryColor,
                          ),
                      maxLines: 1,
                    ),
                    const SizedBox(height: 8),
                    AutoSizeText(
                      exp.period,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textPrimaryColor
                                .withValues(alpha: 0.7),
                          ),
                    ),
                    const SizedBox(height: 16),
                    AutoSizeText(
                      exp.responsibilities.join('\n• '),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppTheme.textPrimaryColor
                                .withValues(alpha: 0.8),
                            height: 1.6,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
