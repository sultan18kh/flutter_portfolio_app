import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../utils/app_theme.dart';

class ModernNavbar extends StatefulWidget {
  final ScrollController scrollController;

  const ModernNavbar({
    super.key,
    required this.scrollController,
  });

  @override
  State<ModernNavbar> createState() => _ModernNavbarState();
}

class _ModernNavbarState extends State<ModernNavbar> {
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    if (widget.scrollController.offset > 50 && !_isScrolled) {
      setState(() => _isScrolled = true);
    } else if (widget.scrollController.offset <= 50 && _isScrolled) {
      setState(() => _isScrolled = false);
    }
  }

  void _scrollToSection(String sectionId) {
    // This will be implemented with the main page
    // For now, we'll use a simple scroll
    final sections = {
      'home': 0.0,
      'about': 800.0,
      'experience': 1600.0,
      'projects': 2400.0,
      'skills': 3200.0,
      'contact': 4000.0,
    };

    final offset = sections[sectionId] ?? 0.0;
    widget.scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 80,
      decoration: BoxDecoration(
        color: _isScrolled
            ? AppTheme.surfaceColor.withValues(alpha: 0.95)
            : Colors.transparent,
        border: _isScrolled
            ? Border(
                bottom: BorderSide(
                  color: AppTheme.primaryColor.withValues(alpha: 0.2),
                  width: 1,
                ),
              )
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Row(
          children: [
            // Logo/Name
            AutoSizeText(
              'SK',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1,
                  ),
            ),

            const SizedBox(width: 8),

            AutoSizeText(
              'Sultan Khan',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),

            const Spacer(),

            // Navigation Items
            Row(
              children: [
                _buildNavItem('Home', 'home'),
                _buildNavItem('About', 'about'),
                _buildNavItem('Experience', 'experience'),
                _buildNavItem('Projects', 'projects'),
                _buildNavItem('Skills', 'skills'),
                _buildNavItem('Contact', 'contact'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(String label, String sectionId) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => _scrollToSection(sectionId),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.transparent,
            ),
            child: AutoSizeText(
              label,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textSecondaryColor,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
