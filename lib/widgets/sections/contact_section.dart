import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/personal_info.dart';
import '../../models/certification.dart';
import '../../utils/app_theme.dart';

class ContactSection extends StatelessWidget {
  final PersonalInfo personalInfo;
  final List<Certification> certifications;

  const ContactSection({
    super.key,
    required this.personalInfo,
    required this.certifications,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Get In Touch'),
          const SizedBox(height: 40),
          LayoutBuilder(
            builder: (context, constraints) {
              final contactInfo = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    'Let\'s work together!',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  AutoSizeText(
                    'I\'m always interested in new opportunities and exciting projects. Feel free to reach out!',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color:
                              AppTheme.textPrimaryColor.withValues(alpha: 0.8),
                          height: 1.6,
                        ),
                  ),
                  const SizedBox(height: 32),
                  // Contact details
                  _buildContactItem(
                    context,
                    Icons.email,
                    'Email',
                    personalInfo.email,
                    () => _launchUrl('mailto:${personalInfo.email}'),
                  ),
                  const SizedBox(height: 16),
                  _buildContactItem(
                    context,
                    Icons.phone,
                    'Phone',
                    personalInfo.phoneNumbers.isNotEmpty
                        ? personalInfo.phoneNumbers.first
                        : 'N/A',
                    () => _launchUrl(
                        'tel:${personalInfo.phoneNumbers.isNotEmpty ? personalInfo.phoneNumbers.first : ''}'),
                  ),
                  const SizedBox(height: 16),
                  _buildContactItem(
                    context,
                    Icons.location_on,
                    'Location',
                    personalInfo.home,
                    null,
                  ),
                  const SizedBox(height: 32),
                  // Social links
                  Row(
                    children: [
                      if (personalInfo.linkedin.isNotEmpty)
                        _buildSocialButton(
                          context,
                          Icons.link,
                          () => _launchUrl(personalInfo.linkedin),
                        ),
                      if (personalInfo.github.isNotEmpty) ...[
                        const SizedBox(width: 16),
                        _buildSocialButton(
                          context,
                          Icons.code,
                          () => _launchUrl(personalInfo.github),
                        ),
                      ],
                    ],
                  ),
                ],
              );
              final certificationsColumn = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    'Certifications',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 20),
                  ...certifications
                      .map((cert) => _buildCertificationCard(context, cert)),
                ],
              );

              if (constraints.maxWidth < 800) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPortrait(),
                    const SizedBox(height: 32),
                    contactInfo,
                    const SizedBox(height: 48),
                    certificationsColumn,
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPortrait(),
                  const SizedBox(width: 40),
                  Expanded(flex: 1, child: contactInfo),
                  const SizedBox(width: 60),
                  Expanded(flex: 1, child: certificationsColumn),
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
      width: 140,
      height: 140,
      padding: const EdgeInsets.all(3),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppTheme.primaryColor, AppTheme.accentColor],
        ),
      ),
      child: ClipOval(
        child: Image.asset(
          'assets/sultan_side_rough.jpg',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              Container(color: AppTheme.surfaceColor),
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

  Widget _buildContactItem(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    VoidCallback? onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            icon,
            color: AppTheme.primaryColor,
            size: 20,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AutoSizeText(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.textPrimaryColor.withValues(alpha: 0.7),
                    ),
              ),
              AutoSizeText(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textPrimaryColor,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton(
      BuildContext context, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppTheme.primaryColor.withValues(alpha: 0.3),
          ),
        ),
        child: Icon(
          icon,
          color: AppTheme.primaryColor,
        ),
      ),
    );
  }

  Widget _buildCertificationCard(BuildContext context, Certification cert) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.primaryColor.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoSizeText(
            cert.name,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          AutoSizeText(
            cert.issuer ?? 'Unknown Issuer',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textPrimaryColor,
                ),
          ),
          const SizedBox(height: 4),
          AutoSizeText(
            cert.date ?? 'Unknown Date',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.textPrimaryColor.withValues(alpha: 0.7),
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
