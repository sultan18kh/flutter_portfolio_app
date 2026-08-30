import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/personal_info.dart';
import '../../utils/app_theme.dart';
import '../reveal_on_scroll.dart';
import '../section_heading.dart';

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
          const RevealOnScroll(child: SectionHeading('Get In Touch')),
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
                    // Contact details — tapping any row copies its value
                    // (a real fix for desktop, where mailto:/tel: often
                    // does nothing without a configured client) and, for
                    // Email/Phone, still attempts to launch the app too.
                    _ContactItemButton(
                      icon: Icons.email,
                      label: 'Email',
                      value: personalInfo.email,
                      copiedText: 'Email copied!',
                      onTap: () => _launchUrl('mailto:${personalInfo.email}'),
                    ),
                    const SizedBox(height: 16),
                    _ContactItemButton(
                      icon: Icons.phone,
                      label: 'Phone',
                      value: personalInfo.phoneNumbers.isNotEmpty
                          ? personalInfo.phoneNumbers.first
                          : 'N/A',
                      copiedText: 'Number copied!',
                      onTap: personalInfo.phoneNumbers.isNotEmpty
                          ? () => _launchUrl(
                              'tel:${personalInfo.phoneNumbers.first}')
                          : null,
                    ),
                    const SizedBox(height: 16),
                    _ContactItemButton(
                      icon: Icons.location_on,
                      label: 'Location',
                      value: personalInfo.home,
                      copiedText: 'Copied!',
                      // AlphaBOLD's Google Maps CID, decoded from the
                      // place's share link — an exact permalink to this one
                      // listing, unlike a text search (which can resolve to
                      // an unrelated same-named place depending on the
                      // viewer's account/location bias).
                      onTap: () => _launchUrl(
                        'https://www.google.com/maps?cid=13263899117268670564',
                      ),
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

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}

/// A contact row that always copies its value to the clipboard on tap
/// (with an inline checkmark-and-glow confirmation) — desktop browsers
/// often have no mail/tel client configured, so mailto:/tel: alone can
/// silently do nothing; copy is a real fallback, not just decoration. When
/// [onTap] is given (Email/Phone), it's still attempted alongside the copy.
class _ContactItemButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final String value;
  final String copiedText;
  final VoidCallback? onTap;

  const _ContactItemButton({
    required this.icon,
    required this.label,
    required this.value,
    required this.copiedText,
    this.onTap,
  });

  @override
  State<_ContactItemButton> createState() => _ContactItemButtonState();
}

class _ContactItemButtonState extends State<_ContactItemButton> {
  bool _copied = false;
  Timer? _revertTimer;

  @override
  void dispose() {
    _revertTimer?.cancel();
    super.dispose();
  }

  void _handleTap() {
    Clipboard.setData(ClipboardData(text: widget.value));
    widget.onTap?.call();
    _revertTimer?.cancel();
    setState(() => _copied = true);
    _revertTimer = Timer(const Duration(milliseconds: 1500), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: _handleTap,
        borderRadius: BorderRadius.circular(12),
        mouseCursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            color: AppTheme.surfaceColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _copied
                  ? AppTheme.accentColor.withValues(alpha: 0.7)
                  : AppTheme.primaryColor.withValues(alpha: 0.3),
            ),
            boxShadow: _copied
                ? [
                    BoxShadow(
                      color: AppTheme.accentColor.withValues(alpha: 0.35),
                      blurRadius: 16,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (child, animation) =>
                    ScaleTransition(scale: animation, child: child),
                child: Icon(
                  _copied ? Icons.check_circle_rounded : widget.icon,
                  key: ValueKey(_copied),
                  color: _copied ? AppTheme.accentColor : AppTheme.primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeText(
                      widget.label,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.textPrimaryColor
                                .withValues(alpha: 0.7),
                          ),
                    ),
                    AutoSizeText(
                      widget.value,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textPrimaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: _copied
                    ? Text(
                        widget.copiedText,
                        key: const ValueKey('copied'),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.accentColor,
                              fontWeight: FontWeight.w600,
                            ),
                      )
                    // Email/Phone still open an app on tap, so they keep
                    // the "opens externally" arrow at rest; only Location
                    // (copy-only, nothing to launch) shows a copy icon.
                    : Icon(
                        widget.onTap != null
                            ? Icons.arrow_outward_rounded
                            : Icons.copy_rounded,
                        key: const ValueKey('rest'),
                        color: AppTheme.primaryColor.withValues(alpha: 0.5),
                        size: widget.onTap != null ? 18 : 16,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
