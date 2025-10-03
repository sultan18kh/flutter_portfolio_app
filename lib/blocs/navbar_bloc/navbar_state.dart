import 'package:equatable/equatable.dart';

abstract class NavbarState extends Equatable {
  const NavbarState();

  @override
  List<Object?> get props => [];
}

class NavbarInitial extends NavbarState {
  const NavbarInitial();
}

class NavbarUpdated extends NavbarState {
  final bool isScrolled;
  final bool isVisible;

  const NavbarUpdated({
    required this.isScrolled,
    required this.isVisible,
  });

  @override
  List<Object?> get props => [isScrolled, isVisible];

  NavbarUpdated copyWith({
    bool? isScrolled,
    bool? isVisible,
  }) {
    return NavbarUpdated(
      isScrolled: isScrolled ?? this.isScrolled,
      isVisible: isVisible ?? this.isVisible,
    );
  }
}
