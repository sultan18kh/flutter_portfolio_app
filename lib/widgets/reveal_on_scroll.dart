import 'package:flutter/material.dart';

/// Provides the page's single [ScrollController] to descendant
/// [RevealOnScroll] widgets, so they all react to one scroll listener
/// instead of each running its own per-frame poll.
class RevealScrollScope extends InheritedWidget {
  final ScrollController controller;

  const RevealScrollScope({
    super.key,
    required this.controller,
    required super.child,
  });

  static ScrollController? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<RevealScrollScope>()
        ?.controller;
  }

  @override
  bool updateShouldNotify(RevealScrollScope oldWidget) =>
      oldWidget.controller != controller;
}

/// Fades and slides [child] into place the first time it scrolls into view.
///
/// Visibility is checked off the shared [RevealScrollScope] controller's
/// scroll events (plus once on mount/dependency change), not a per-instance
/// per-frame ticker, so having many of these on a page costs one listener
/// each rather than N independent render loops.
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
    with SingleTickerProviderStateMixin {
  final GlobalKey _key = GlobalKey();
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<double> _dy;
  ScrollController? _scrollController;
  bool _revealed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    _dy = Tween<double>(begin: 32, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _checkVisibility();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final controller = RevealScrollScope.maybeOf(context);
    if (controller != _scrollController) {
      _scrollController?.removeListener(_checkVisibility);
      _scrollController = controller;
      _scrollController?.addListener(_checkVisibility);
    }
    if (!_revealed) _checkVisibility();
  }

  void _checkVisibility() {
    if (_revealed || !mounted) return;
    final renderObject = _key.currentContext?.findRenderObject();
    if (renderObject is! RenderBox || !renderObject.attached) return;

    final top = renderObject.localToGlobal(Offset.zero).dy;
    final screenHeight = MediaQuery.of(context).size.height;

    if (top < screenHeight * 0.88) {
      _revealed = true;
      Future.delayed(widget.delay, () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_checkVisibility);
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
