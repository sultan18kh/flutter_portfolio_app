import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../utils/app_theme.dart';

/// The one consistent section-title treatment shared by every major section
/// (About, Skills, Experience, Certifications, Projects, Contact): a
/// gradient accent bar plus a single fixed type scale, always left-aligned
/// regardless of what alignment the section's own body content uses.
class SectionHeading extends StatelessWidget {
  final String title;

  const SectionHeading(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    // The width: infinity forces this to claim the full row regardless of
    // the parent Column's own crossAxisAlignment (some sections center
    // their body content) — without it, Align has no extra space to push
    // into and silently does nothing.
    return SizedBox(
      width: double.infinity,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisSize: MainAxisSize.min,
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
              title,
              maxLines: 1,
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
