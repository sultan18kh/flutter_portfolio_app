import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/personal_info.dart';
import '../../utils/app_theme.dart';

class HeroSection extends StatelessWidget {
  final PersonalInfo personalInfo;

  const HeroSection({
    super.key,
    required this.personalInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 80),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Profile Image
          Container(
            width: 208,
            height: 208,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppTheme.primaryColor, AppTheme.accentColor],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryColor.withValues(alpha: 0.35),
                  blurRadius: 24,
                  spreadRadius: 2,
                  offset: const Offset(-6, 0),
                ),
                BoxShadow(
                  color: AppTheme.accentColor.withValues(alpha: 0.35),
                  blurRadius: 24,
                  spreadRadius: 2,
                  offset: const Offset(6, 0),
                ),
              ],
            ),
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.backgroundColor,
              ),
              child: ClipOval(
                child: Image.asset(
                  personalInfo.profileImage,
                  width: 192,
                  height: 192,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback if image doesn't exist
                    return Container(
                      width: 192,
                      height: 192,
                      color: AppTheme.surfaceColor,
                      child: const Icon(
                        Icons.person,
                        size: 100,
                        color: AppTheme.primaryColor,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),

          // Name
          AutoSizeText(
            personalInfo.name,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
            maxLines: 1,
          ),
          const SizedBox(height: 16),

          // Title
          AutoSizeText(
            personalInfo.title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppTheme.textPrimaryColor,
                  fontWeight: FontWeight.w300,
                ),
            maxLines: 2,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          // Description
          AutoSizeText(
            personalInfo.profile,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.textPrimaryColor.withValues(alpha: 0.8),
                  height: 1.6,
                ),
            maxLines: 4,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),

          // CTA Buttons
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 16,
            runSpacing: 16,
            children: [
              ElevatedButton(
                onPressed: _emailContact,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Get In Touch'),
              ),
              OutlinedButton(
                onPressed: _downloadCv,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.primaryColor,
                  side: const BorderSide(color: AppTheme.primaryColor),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Download CV'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _emailContact() async {
    final uri = Uri(
      scheme: 'mailto',
      path: personalInfo.email,
      query:
          'subject=${Uri.encodeComponent("Let's Connect")}&body=${Uri.encodeComponent("I love the work you're doing and wanna get in touch.")}',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _downloadCv() async {
    final uri = Uri.base.resolve('assets/docs/sultan-khan-cv.pdf');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, webOnlyWindowName: '_blank');
    }
  }
}
