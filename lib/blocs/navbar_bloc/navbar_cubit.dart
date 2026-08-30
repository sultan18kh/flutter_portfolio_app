import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'navbar_state.dart';
import '../../utils/section_keys.dart';

class NavbarCubit extends Cubit<NavbarState> {
  NavbarCubit() : super(const NavbarInitial());

  void updateScrollState({
    required bool isScrolled,
    required bool isVisible,
  }) {
    if (state is NavbarUpdated) {
      final currentState = state as NavbarUpdated;
      if (currentState.isScrolled != isScrolled ||
          currentState.isVisible != isVisible) {
        emit(NavbarUpdated(
          isScrolled: isScrolled,
          isVisible: isVisible,
        ));
      }
    } else {
      emit(NavbarUpdated(
        isScrolled: isScrolled,
        isVisible: isVisible,
      ));
    }
  }

  void reset() {
    emit(const NavbarInitial());
  }

  void initializeScrollListener(ScrollController scrollController) {
    scrollController.addListener(() {
      final offset = scrollController.offset;
      final isScrolled = offset > 100;
      final isVisible = offset < 50 || offset > 100;

      updateScrollState(
        isScrolled: isScrolled,
        isVisible: isVisible,
      );
    });
  }

  /// Resting (unclamped) scroll offset for [sectionId], already at
  /// [revealOffset] (its flush-at-viewport-top reveal offset). Shared by
  /// [scrollToSection] and [PhotoMorphProgress] so the two can never drift
  /// out of sync on where a section actually settles.
  ///
  /// Home is a special case: it sits right after the artificial top
  /// reserve (see landing_page's `navbarClearance`-sized leading
  /// SizedBox, which exists so the top-pinned navbar has room to float
  /// over Hero content) — landing flush there would just leave that
  /// reserve as an oversized gap, so go all the way to the top instead.
  /// Every other section has nothing reserved above it and lands flush,
  /// putting its heading exactly at its own real y-coordinate.
  static double restingOffsetFor(String sectionId, double revealOffset) {
    if (sectionId == 'home') return 0;
    return revealOffset;
  }

  void scrollToSection(String sectionId) {
    final targetContext = SectionKeys.keys[sectionId]?.currentContext;
    final renderObject = targetContext?.findRenderObject();
    if (renderObject == null) return;

    final viewport = RenderAbstractViewport.of(renderObject);
    final revealOffset = viewport.getOffsetToReveal(renderObject, 0.0).offset;
    final scrollable = Scrollable.of(targetContext!);
    final position = scrollable.position;
    final targetOffset = restingOffsetFor(sectionId, revealOffset).clamp(
      position.minScrollExtent,
      position.maxScrollExtent,
    );

    // animateTo drives a DrivenScrollActivity, not a ballistic one, so
    // LandingPage's section-snap ScrollPhysics (createBallisticSimulation)
    // is never consulted during this jump — no cross-component guard needed.
    position.animateTo(
      targetOffset,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOutCubic,
    );
  }
}
