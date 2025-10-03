import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
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
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 80),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Profile Image
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppTheme.primaryColor,
                width: 4,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryColor.withValues(alpha: 0.3),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Scroll to contact section
                },
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
              const SizedBox(width: 16),
              OutlinedButton(
                onPressed: () {
                  // Download CV
                },
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
}
