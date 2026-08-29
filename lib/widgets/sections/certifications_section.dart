import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../../models/certification.dart';
import '../../utils/app_theme.dart';
import '../reveal_on_scroll.dart';
import '../section_heading.dart';

class CertificationsSection extends StatelessWidget {
  final List<Certification> certifications;

  const CertificationsSection({
    super.key,
    required this.certifications,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const RevealOnScroll(
            child: SectionHeading('Certifications'),
          ),
          const SizedBox(height: 16),
          RevealOnScroll(
            delay: const Duration(milliseconds: 80),
            child: AutoSizeText(
              'Microsoft-certified across Azure fundamentals, applied skills, and associate-level expertise.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppTheme.textSecondaryColor,
                  ),
              maxLines: 2,
            ),
          ),
          const SizedBox(height: 48),

          // Certification list
          LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = constraints.maxWidth < 700
                  ? 1
                  : constraints.maxWidth < 1100
                      ? 2
                      : 2;
              return Wrap(
                spacing: 24,
                runSpacing: 24,
                children: certifications.asMap().entries.map((entry) {
                  final width =
                      (constraints.maxWidth - (24 * (crossAxisCount - 1))) /
                          crossAxisCount;
                  return SizedBox(
                    width: width.clamp(260, constraints.maxWidth),
                    child: RevealOnScroll(
                      delay: Duration(milliseconds: 160 + entry.key * 90),
                      child: _buildCertificationCard(context, entry.value),
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

  // Real Microsoft badge art per credential tier, not a generic icon.
  String _badgeAssetFor(Certification cert) {
    if (cert.name.startsWith('APL-7008')) {
      return 'assets/certs/applied_skills.png';
    }
    if (cert.name.startsWith('AI-103')) {
      return 'assets/certs/associate.png';
    }
    return 'assets/certs/fundamentals.png';
  }

  Widget _buildCertificationCard(BuildContext context, Certification cert) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.primaryColor.withValues(alpha: 0.25),
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryColor.withValues(alpha: 0.25),
                  blurRadius: 16,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Image.asset(
              _badgeAssetFor(cert),
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [AppTheme.primaryColor, AppTheme.accentColor],
                  ),
                ),
                child: const Icon(
                  Icons.workspace_premium,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoSizeText(
                  cert.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppTheme.textPrimaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                  maxLines: 2,
                ),
                if (cert.issuer != null) ...[
                  const SizedBox(height: 6),
                  AutoSizeText(
                    cert.issuer!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.primaryColor,
                        ),
                  ),
                ],
                if (cert.date != null) ...[
                  const SizedBox(height: 4),
                  AutoSizeText(
                    cert.date!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.textPrimaryColor.withValues(alpha: 0.6),
                        ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
