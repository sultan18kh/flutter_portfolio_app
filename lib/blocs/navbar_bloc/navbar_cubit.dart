import 'package:flutter/material.dart';
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

  void scrollToSection(String sectionId) {
    final targetContext = SectionKeys.keys[sectionId]?.currentContext;
    if (targetContext == null) return;

    Scrollable.ensureVisible(
      targetContext,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOutCubic,
      alignment: 0.0,
    );
  }
}
