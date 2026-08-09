import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:ui';
import '../utils/app_theme.dart';
import '../blocs/navbar_bloc/navbar_cubit.dart';
import '../blocs/navbar_bloc/navbar_state.dart';

class ModernNavbar extends StatelessWidget {
  final ScrollController scrollController;

  const ModernNavbar({
    super.key,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          NavbarCubit()..initializeScrollListener(scrollController),
      child: const _ModernNavbarView(),
    );
  }
}

class _ModernNavbarView extends StatefulWidget {
  const _ModernNavbarView();

  @override
  State<_ModernNavbarView> createState() => _ModernNavbarViewState();
}

class _ModernNavbarViewState extends State<_ModernNavbarView>
    with TickerProviderStateMixin {
  static const double _mobileBreakpoint = 800;
  static const List<(String, String)> _navItems = [
    ('Home', 'home'),
    ('About', 'about'),
    ('Experience', 'experience'),
    ('Projects', 'projects'),
    ('Skills', 'skills'),
    ('Contact', 'contact'),
  ];

  late AnimationController _slideController;
  late AnimationController _fadeController;
  late AnimationController _positionController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _positionSlideAnimation;
  late Animation<double> _positionFadeAnimation;
  bool _mobileMenuOpen = false;

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _positionController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Initialize animations
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    // Position transition animations (for smooth top to bottom movement)
    _positionSlideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: const Offset(0, 1),
    ).animate(CurvedAnimation(
      parent: _positionController,
      curve: Curves.easeInOutCubic,
    ));

    _positionFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _positionController,
      curve: Curves.easeInOut,
    ));

    // Start with navbar visible
    _slideController.forward();
    _fadeController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    _positionController.dispose();
    super.dispose();
  }

  void _handleStateChange(NavbarState state) {
    if (state is NavbarUpdated) {
      // Trigger position transition animation when moving from top to bottom
      if (state.isScrolled) {
        // Moving to bottom position
        _positionController.forward();
      } else {
        // Moving to top position
        _positionController.reverse();
      }

      if (state.isVisible) {
        _slideController.forward();
        _fadeController.forward();
      } else {
        _slideController.reverse();
        _fadeController.reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NavbarCubit, NavbarState>(
      listener: (context, state) => _handleStateChange(state),
      child: BlocBuilder<NavbarCubit, NavbarState>(
        builder: (context, state) {
          final isScrolled = state is NavbarUpdated ? state.isScrolled : false;

          return AnimatedBuilder(
            animation: Listenable.merge([
              _slideAnimation,
              _fadeAnimation,
              _positionSlideAnimation,
              _positionFadeAnimation
            ]),
            builder: (context, child) {
              return Positioned.fill(
                child: Stack(
                  clipBehavior: Clip.hardEdge,
                  children: [
                    // Top navbar
                    if (!isScrolled)
                      Positioned(
                        top: 20,
                        left: 20,
                        right: 20,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: FadeTransition(
                            opacity: _fadeAnimation,
                            child: _buildNavbarContent(isScrolled),
                          ),
                        ),
                      ),

                    // Bottom navbar with position transition animations
                    if (isScrolled)
                      Positioned(
                        bottom: 100,
                        left: 20,
                        right: 20,
                        child: SlideTransition(
                          position: _positionSlideAnimation,
                          child: FadeTransition(
                            opacity: _positionFadeAnimation,
                            child: _buildNavbarContent(isScrolled),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildNavbarContent(bool isScrolled) {
    final isMobile = MediaQuery.of(context).size.width < _mobileBreakpoint;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildGlassPanel(
          isScrolled: isScrolled,
          height: 70,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
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
                if (!isMobile) ...[
                  const SizedBox(width: 8),
                  AutoSizeText(
                    'Sultan Khan',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isScrolled
                              ? AppTheme.textPrimaryColor
                              : AppTheme.textPrimaryColor
                                  .withValues(alpha: 0.9),
                        ),
                  ),
                ],

                const Spacer(),

                if (isMobile)
                  _buildMenuToggle(isScrolled)
                else
                  Row(
                    children: [
                      for (final (label, id) in _navItems)
                        _buildNavItem(label, id, isScrolled),
                    ],
                  ),
              ],
            ),
          ),
        ),
        if (isMobile && _mobileMenuOpen) ...[
          const SizedBox(height: 12),
          _buildGlassPanel(
            isScrolled: isScrolled,
            height: null,
            forceScrim: true,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final (label, id) in _navItems)
                    _buildMobileNavItem(label, id, isScrolled),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildGlassPanel({
    required bool isScrolled,
    required double? height,
    required Widget child,
    bool forceScrim = false,
  }) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        // * Liquid glass effect with primary color tint
        color: isScrolled
            ? AppTheme.primaryColor.withValues(alpha: 0.1)
            : Colors.transparent,
        border: Border.all(
          color: isScrolled || forceScrim
              ? AppTheme.primaryColor.withValues(alpha: 0.3)
              : Colors.transparent,
          width: 1.5,
        ),
        // * Glass morphism effect
        boxShadow: isScrolled || forceScrim
            ? [
                BoxShadow(
                  color: AppTheme.primaryColor.withValues(alpha: 0.1),
                  blurRadius: 20,
                  spreadRadius: 0,
                  offset: const Offset(0, 8),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  spreadRadius: 0,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: isScrolled ? 20 : 0,
            sigmaY: isScrolled ? 20 : 0,
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: isScrolled
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppTheme.primaryColor.withValues(alpha: 0.05),
                        AppTheme.primaryColor.withValues(alpha: 0.15),
                      ],
                    )
                  : null,
              color: (!isScrolled && forceScrim)
                  ? AppTheme.backgroundColor.withValues(alpha: 0.85)
                  : null,
            ),
            child: child,
          ),
        ),
      ),
    );
  }

  Widget _buildMenuToggle(bool isScrolled) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => setState(() => _mobileMenuOpen = !_mobileMenuOpen),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: _mobileMenuOpen
                ? AppTheme.primaryColor.withValues(alpha: 0.15)
                : Colors.transparent,
            border: Border.all(
              color: AppTheme.primaryColor.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Icon(
            _mobileMenuOpen ? Icons.close : Icons.menu,
            color: AppTheme.primaryColor,
            size: 22,
          ),
        ),
      ),
    );
  }

  Widget _buildMobileNavItem(String label, String sectionId, bool isScrolled) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          context.read<NavbarCubit>().scrollToSection(sectionId);
          setState(() => _mobileMenuOpen = false);
        },
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: AppTheme.primaryColor.withValues(alpha: 0.08),
          ),
          child: AutoSizeText(
            label,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textPrimaryColor,
                ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(String label, String sectionId, bool isScrolled) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => context.read<NavbarCubit>().scrollToSection(sectionId),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: isScrolled
                  ? AppTheme.primaryColor.withValues(alpha: 0.1)
                  : Colors.transparent,
              border: isScrolled
                  ? Border.all(
                      color: AppTheme.primaryColor.withValues(alpha: 0.2),
                      width: 1,
                    )
                  : null,
            ),
            child: AutoSizeText(
              label,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: isScrolled
                        ? AppTheme.textPrimaryColor
                        : AppTheme.textSecondaryColor,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
