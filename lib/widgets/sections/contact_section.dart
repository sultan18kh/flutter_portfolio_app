import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/personal_info.dart';
import '../../utils/app_theme.dart';
import '../reveal_on_scroll.dart';

class ContactSection extends StatelessWidget {
  final PersonalInfo personalInfo;

  const ContactSection({
    super.key,
    required this.personalInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RevealOnScroll(child: _buildSectionTitle(context)),
          const SizedBox(height: 40),
          RevealOnScroll(
            delay: const Duration(milliseconds: 100),
            child: LayoutBuilder(
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
                            color: AppTheme.textPrimaryColor
                                .withValues(alpha: 0.8),
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
                  ],
                );

                if (constraints.maxWidth < 800) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPortrait(),
                      const SizedBox(height: 32),
                      contactInfo,
                    ],
                  );
                }

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPortrait(),
                    const SizedBox(width: 48),
                    Expanded(child: contactInfo),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPortrait() {
    return Container(
      width: 160,
      height: 160,
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
        // Caricature crop has a transparent background — let the page's
        // own dark surface show through rather than a jarring white box.
        child: Container(
          color: AppTheme.backgroundColor,
          child: Image.asset(
            'assets/sultan_caricature_portrait.png',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                Container(color: AppTheme.surfaceColor),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context) {
    return AutoSizeText(
      'Get In Touch',
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: AppTheme.primaryColor,
            fontWeight: FontWeight.bold,
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
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        mouseCursor:
            onTap != null ? SystemMouseCursors.click : MouseCursor.defer,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            color: AppTheme.surfaceColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: onTap != null
                  ? AppTheme.primaryColor.withValues(alpha: 0.3)
                  : AppTheme.primaryColor.withValues(alpha: 0.12),
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: AppTheme.primaryColor,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeText(
                      label,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.textPrimaryColor
                                .withValues(alpha: 0.7),
                          ),
                    ),
                    AutoSizeText(
                      value,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textPrimaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),
              if (onTap != null)
                Icon(
                  Icons.arrow_outward_rounded,
                  color: AppTheme.primaryColor.withValues(alpha: 0.6),
                  size: 18,
                ),
            ],
          ),
        ),
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
