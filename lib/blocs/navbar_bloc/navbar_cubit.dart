import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'navbar_state.dart';

class NavbarCubit extends Cubit<NavbarState> {
  ScrollController? _scrollController;

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
    _scrollController = scrollController;
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
    if (_scrollController == null) return;

    final sections = {
      'home': 0.0,
      'about': 800.0,
      'experience': 1600.0,
      'projects': 2400.0,
      'skills': 3200.0,
      'contact': 4000.0,
    };

    final offset = sections[sectionId] ?? 0.0;
    _scrollController!.animateTo(
      offset,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOutCubic,
    );
  }
}
