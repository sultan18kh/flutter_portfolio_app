import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../blocs/navbar_bloc/navbar_cubit.dart';
import '../utils/app_theme.dart';
import '../utils/section_keys.dart';

/// A thin gradient rail fixed to the very top edge of the viewport that
/// fills left-to-right as the visitor scrolls the whole page — ties every
/// section into one continuous journey instead of a stack of independent
/// sections, without touching or competing with any section's own moment.
///
/// Carries one small tell beyond the fill itself: a hairline mark at each
/// section's position along the rail, dim until the fill reaches it, then
/// brightening — a quiet "you just started a new section" cue.
class ScrollProgressRail extends StatefulWidget {
  final ScrollController controller;

  const ScrollProgressRail({super.key, required this.controller});

  @override
  State<ScrollProgressRail> createState() => _ScrollProgressRailState();
}

class _ScrollProgressRailState extends State<ScrollProgressRail> {
  double _progress = 0;
  List<double> _sectionFractions = const [];

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_update);
    WidgetsBinding.instance.addPostFrameCallback((_) => _update());
  }

  @override
  void dispose() {
    widget.controller.removeListener(_update);
    super.dispose();
  }

  void _update() {
    if (!widget.controller.hasClients) return;
    final position = widget.controller.position;
    final max = position.maxScrollExtent;
    final next = max > 0 ? (widget.controller.offset / max).clamp(0.0, 1.0) : 0.0;

    var fractions = _sectionFractions;
    if (max > 0) {
      final computed = <double>[];
      for (final entry in SectionKeys.keys.entries) {
        final renderObject = entry.value.currentContext?.findRenderObject();
        if (renderObject == null) continue;
        final viewport = RenderAbstractViewport.of(renderObject);
        final revealOffset =
            viewport.getOffsetToReveal(renderObject, 0.0).offset;
        final target = NavbarCubit.restingOffsetFor(entry.key, revealOffset)
            .clamp(0.0, max);
        final fraction = target / max;
        // Skip the very start/end — a mark right at either edge of the
        // rail would just read as a stray pixel, not a section cue.
        if (fraction > 0.01 && fraction < 0.99) computed.add(fraction);
      }
      computed.sort();
      if (!_fractionsEqual(computed, _sectionFractions)) {
        fractions = computed;
      }
    }

    if ((next - _progress).abs() > 0.001 ||
        !identical(fractions, _sectionFractions)) {
      setState(() {
        _progress = next;
        _sectionFractions = fractions;
      });
    }
  }

  bool _fractionsEqual(List<double> a, List<double> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if ((a[i] - b[i]).abs() > 0.001) return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SizedBox(
            height: 3,
            width: constraints.maxWidth,
            child: Stack(
              children: [
                Align(
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
                for (final fraction in _sectionFractions)
                  _SectionTick(
                    left: fraction * constraints.maxWidth,
                    reached: _progress >= fraction - 0.002,
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SectionTick extends StatelessWidget {
  final double left;
  final bool reached;

  const _SectionTick({required this.left, required this.reached});

  static const _width = 2.5;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left - _width / 2,
      top: 0,
      bottom: 0,
      width: _width,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: reached ? 0.95 : 0.32),
          boxShadow: reached
              ? [
                  BoxShadow(
                    color: Colors.white.withValues(alpha: 0.8),
                    blurRadius: 4,
                  ),
                  BoxShadow(
                    color: AppTheme.accentColor.withValues(alpha: 0.7),
                    blurRadius: 9,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
      ),
    );
  }
}
