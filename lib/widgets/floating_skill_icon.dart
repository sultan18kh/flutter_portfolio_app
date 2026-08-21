import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../utils/app_theme.dart';

class FloatingSkillIcon extends StatefulWidget {
  final String assetPath;
  final String skillName;
  final double size;
  final double floatingRange;
  final Duration animationDuration;
  final Duration delay;

  const FloatingSkillIcon({
    super.key,
    required this.assetPath,
    required this.skillName,
    this.size = 80.0,
    this.floatingRange = 20.0,
    this.animationDuration = const Duration(seconds: 3),
    this.delay = Duration.zero,
  });

  @override
  State<FloatingSkillIcon> createState() => _FloatingSkillIconState();
}

class _FloatingSkillIconState extends State<FloatingSkillIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _floatAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    // * Vertical floating animation (sine wave)
    _floatAnimation = Tween<double>(
      begin: -widget.floatingRange,
      end: widget.floatingRange,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // * Subtle rotation animation
    _rotationAnimation = Tween<double>(
      begin: -0.05,
      end: 0.05,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // * Subtle scale pulsing
    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // * Delay the animation start
    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.repeat(reverse: true);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onHoverChanged(true),
      onExit: (_) => _onHoverChanged(false),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.translate(
            offset: _isHovered ? Offset.zero : Offset(0, _floatAnimation.value),
            child: Transform.rotate(
              angle: _isHovered ? 0 : _rotationAnimation.value,
              child: Transform.scale(
                scale: _isHovered ? 1.1 : _scaleAnimation.value,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: widget.size,
                      height: widget.size,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _isHovered
                            ? AppTheme.primaryColor.withValues(alpha: 0.1)
                            : AppTheme.cardColor,
                        borderRadius: BorderRadius.circular(16),
                        border: _isHovered
                            ? Border.all(
                                color: AppTheme.primaryColor,
                                width: 2,
                              )
                            : null,
                        boxShadow: [
                          BoxShadow(
                            color: _isHovered
                                ? AppTheme.primaryColor.withValues(alpha: 0.4)
                                : AppTheme.primaryColor.withValues(alpha: 0.2),
                            blurRadius: _isHovered ? 20 : 10,
                            spreadRadius: _isHovered ? 4 : 2,
                          ),
                          if (_isHovered)
                            BoxShadow(
                              color:
                                  AppTheme.primaryColor.withValues(alpha: 0.3),
                              blurRadius: 30,
                              spreadRadius: 8,
                            ),
                        ],
                      ),
                      child: widget.assetPath.toLowerCase().endsWith('.svg')
                          ? SvgPicture.asset(
                              widget.assetPath,
                              width: widget.size * 0.6,
                              height: widget.size * 0.6,
                              fit: BoxFit.contain,
                            )
                          : Image.asset(
                              widget.assetPath,
                              width: widget.size * 0.6,
                              height: widget.size * 0.6,
                              fit: BoxFit.contain,
                            ),
                    ),
                    Visibility(
                      visible: _isHovered,
                      child: Container(
                        margin: const EdgeInsets.only(top: 8),
                        child: SizedBox(
                          width: widget.size,
                          child: AutoSizeText(
                            widget.skillName,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            minFontSize: 10,
                            style: TextStyle(
                              color:
                                  AppTheme.primaryColor.withValues(alpha: 0.7),
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _onHoverChanged(bool isHovered) {
    setState(() {
      _isHovered = isHovered;
    });
  }
}
