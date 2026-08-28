import 'package:flutter/material.dart';

/// Stable keys for the two photo widgets bridged by [HeroAboutMorph]'s
/// scroll-linked shared-element transition.
class MorphKeys {
  static final GlobalKey heroPhoto = GlobalKey(debugLabel: 'heroPhoto');
  static final GlobalKey aboutPhoto = GlobalKey(debugLabel: 'aboutPhoto');
  static final GlobalKey stackOrigin = GlobalKey(debugLabel: 'stackOrigin');
}
