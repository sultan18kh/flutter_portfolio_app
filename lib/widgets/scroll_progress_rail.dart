import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

/// A thin gradient rail fixed to the very top edge of the viewport that
/// fills left-to-right as the visitor scrolls the whole page — ties every
/// section into one continuous journey instead of a stack of independent
/// sections, without touching or competing with any section's own moment.
class ScrollProgressRail extends StatefulWidget {
  final ScrollController controller;

  const ScrollProgressRail({super.key, required this.controller});

  @override
  State<ScrollProgressRail> createState() => _ScrollProgressRailState();
}

class _ScrollProgressRailState extends State<ScrollProgressRail> {
  double _progress = 0;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_update);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_update);
    super.dispose();
  }

  void _update() {
    if (!widget.controller.hasClients) return;
    final max = widget.controller.position.maxScrollExtent;
    final next =
        max > 0 ? (widget.controller.offset / max).clamp(0.0, 1.0) : 0.0;
    if ((next - _progress).abs() > 0.001) {
      setState(() => _progress = next);
    }
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Align(
        alignment: Alignment.topLeft,
        child: FractionallySizedBox(
          widthFactor: _progress,
          child: Container(
            height: 3,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppTheme.primaryColor, AppTheme.accentColor],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryColor.withValues(alpha: 0.6),
                  blurRadius: 8,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
