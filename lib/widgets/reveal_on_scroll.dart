import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// Fades and slides [child] into place the first time it scrolls into view.
///
/// Visibility is polled via a per-frame [Ticker] rather than an ancestor
/// [Scrollable]'s position listener, since a reveal target nested inside its
/// own scroll boundary (e.g. a shrink-wrapped GridView) would otherwise
/// attach to that inner, never-moving position and never fire.
class RevealOnScroll extends StatefulWidget {
  final Widget child;
  final Duration delay;

  const RevealOnScroll({
    super.key,
    required this.child,
    this.delay = Duration.zero,
  });

  @override
  State<RevealOnScroll> createState() => _RevealOnScrollState();
}

class _RevealOnScrollState extends State<RevealOnScroll>
    with TickerProviderStateMixin {
  final GlobalKey _key = GlobalKey();
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<double> _dy;
  Ticker? _visibilityTicker;
  bool _revealed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    _dy = Tween<double>(begin: 32, end: 0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _checkVisibility();
      if (!_revealed) {
        _visibilityTicker = createTicker((_) => _checkVisibility())..start();
      }
    });
  }

  void _checkVisibility() {
    if (_revealed || !mounted) return;
    final renderObject = _key.currentContext?.findRenderObject();
    if (renderObject is! RenderBox || !renderObject.attached) return;

    final top = renderObject.localToGlobal(Offset.zero).dy;
    final screenHeight = MediaQuery.of(context).size.height;

    if (top < screenHeight * 0.88) {
      _revealed = true;
      _visibilityTicker?.stop();
      _visibilityTicker?.dispose();
      _visibilityTicker = null;
      Future.delayed(widget.delay, () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _visibilityTicker?.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: _key,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) => Opacity(
          opacity: _fade.value,
          child: Transform.translate(
            offset: Offset(0, _dy.value),
            child: child,
          ),
        ),
        child: widget.child,
      ),
    );
  }
}
