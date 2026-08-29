import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../utils/app_theme.dart';
import '../reveal_on_scroll.dart';

class SocialsSection extends StatelessWidget {
  const SocialsSection({super.key});

  // Fill in the empty urls below with real profile links.
  static const List<(String name, String icon, String url)> _socials = [
    (
      'LinkedIn',
      'assets/socials/linkedin.svg',
      'https://linkedin.com/in/sultan-khan-278014121'
    ),
    ('GitHub', 'assets/skills/github.svg', 'https://github.com/sultan18kh'),
    (
      'Microsoft Learn',
      'assets/socials/microsoft-learn.svg',
      'https://learn.microsoft.com/en-gb/users/sultankhan-6242/'
    ),
    ('WhatsApp', 'assets/socials/whatsapp.svg', 'https://wa.me/923554776815'),
    (
      'Instagram',
      'assets/socials/instagram.svg',
      'https://www.instagram.com/sultankh18/'
    ),
    (
      'Threads',
      'assets/socials/threads.svg',
      'https://www.threads.com/@sultankh18'
    ),
    (
      'Facebook',
      'assets/socials/facebook.svg',
      'https://www.facebook.com/sultankh1895'
    ),
    ('X', 'assets/socials/x.svg', 'https://x.com/sultan18kh'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      // Sits directly beneath Contact as its closing beat, not a fresh
      // section — less top padding, no competing headline weight.
      padding: const EdgeInsets.fromLTRB(40, 0, 40, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RevealOnScroll(child: _buildSectionTitle(context)),
          const SizedBox(height: 20),
          RevealOnScroll(
            delay: const Duration(milliseconds: 80),
            child: Wrap(
              spacing: 20,
              runSpacing: 20,
              children: _socials
                  .map((social) => _buildSocialButton(context, social))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context) {
    return AutoSizeText(
      'Find me online',
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppTheme.textSecondaryColor,
            fontWeight: FontWeight.w600,
          ),
    );
  }

  Widget _buildSocialButton(
    BuildContext context,
    (String name, String icon, String url) social,
  ) {
    final (name, icon, url) = social;
    final hasLink = url.isNotEmpty;

    return Tooltip(
      message: hasLink ? name : '$name (link coming soon)',
      child: InkWell(
        onTap: hasLink ? () => _launchUrl(url) : null,
        borderRadius: BorderRadius.circular(14),
        child: Opacity(
          opacity: hasLink ? 1 : 0.35,
          child: Container(
            width: 56,
            height: 56,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.cardColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: AppTheme.primaryColor.withValues(alpha: 0.3),
              ),
            ),
            child: SvgPicture.asset(icon),
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
