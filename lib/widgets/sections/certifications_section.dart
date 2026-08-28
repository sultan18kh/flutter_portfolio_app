import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../../models/certification.dart';
import '../../utils/app_theme.dart';
import '../reveal_on_scroll.dart';

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
          RevealOnScroll(
            child: _buildSectionTitle(context),
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

  Widget _buildSectionTitle(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 6,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppTheme.primaryColor, AppTheme.accentColor],
            ),
          ),
        ),
        const SizedBox(width: 16),
        AutoSizeText(
          'Certifications',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
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
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [AppTheme.primaryColor, AppTheme.accentColor],
              ),
            ),
            child: const Icon(
              Icons.workspace_premium,
              color: Colors.white,
              size: 24,
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
